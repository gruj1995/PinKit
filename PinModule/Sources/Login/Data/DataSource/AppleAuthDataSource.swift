//
//  AppleAuthDataSource.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import AuthenticationServices
import UIKit
import PinCore

@MainActor
public final class AppleAuthDataSource: NSObject {
    
    private var signInContinuation: CheckedContinuation<LoginResult, Never>?
    private let appleIDProvider = ASAuthorizationAppleIDProvider()
    
    public override init() {
        super.init()
    }
    
    public func signIn() async -> LoginResult {
        await withCheckedContinuation { continuation in
            self.signInContinuation = continuation
            
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthDataSource: ASAuthorizationControllerDelegate {
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken,
              let tokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            signInContinuation?.resume(returning: .failure(.tokenNotFound))
            signInContinuation = nil
            return
        }
        
        let fullName = appleIDCredential.fullName
        let name = [fullName?.givenName, fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
        
        let credential = LoginCredential(
            platform: .apple,
            token: tokenString,
            name: name.isEmpty ? nil : name,
            email: appleIDCredential.email
        )
        
        signInContinuation?.resume(returning: .success(credential))
        signInContinuation = nil
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        PinLogger.log("Apple Sign In Error: \(error.localizedDescription)")
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                signInContinuation?.resume(returning: .cancelled)
            case .failed:
                signInContinuation?.resume(returning: .failure(.authorizationFailed(authError.localizedDescription)))
            case .invalidResponse:
                signInContinuation?.resume(returning: .failure(.authorizationFailed("Invalid response")))
            case .notHandled:
                signInContinuation?.resume(returning: .failure(.authorizationFailed("Not handled")))
            case .unknown:
                signInContinuation?.resume(returning: .failure(.unknown(authError.localizedDescription)))
            default:
                signInContinuation?.resume(returning: .failure(.unknown(authError.localizedDescription)))
            }
        } else {
            signInContinuation?.resume(returning: .failure(.authorizationFailed(error.localizedDescription)))
        }
        
        signInContinuation = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleAuthDataSource: ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available for Apple Sign In")
        }
        return window
    }
}
