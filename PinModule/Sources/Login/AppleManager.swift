//
//  AppleManager.swift
//  app
//
//  Created by NB on 8/7/2020.
//  Copyright © 2020 yoku. All rights reserved.
//

import AuthenticationServices
import UIKit

public class AppleManager: NSObject, LoginProtocol {
    // MARK: Public

    @MainActor
    public func login() async -> LoginResult {
        return await withCheckedContinuation { continuation in
            self.loginContinuation = continuation
            
            let authorizationAppleIDRequest = appleIDProvider.createRequest()
            authorizationAppleIDRequest.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [authorizationAppleIDRequest])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    // MARK: Internal

    public let platform: LoginPlatform = .apple

    // MARK: Private

    private let appleIDProvider = ASAuthorizationAppleIDProvider()
    private var loginContinuation: CheckedContinuation<LoginResult, Never>?
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleManager: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindowCompact!
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleManager: ASAuthorizationControllerDelegate {
    /// 授權成功
    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken,
              let appleJWT = String(data: appleIDToken, encoding: .utf8)
        else {
            loginContinuation?.resume(returning: .failure(.tokenNotFound))
            loginContinuation = nil
            return
        }

        let familyName = appleIDCredential.fullName?.familyName ?? ""
        let givenName = appleIDCredential.fullName?.givenName ?? ""
        let name = familyName + givenName
        let loginInfo = LoginInfo(token: appleJWT, name: name.isEmpty ? nil : name)
        
        loginContinuation?.resume(returning: .success(loginInfo))
        loginContinuation = nil
    }

    /// 授權失敗
    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        PinLogger.log(error.unwrapDescription)
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                loginContinuation?.resume(returning: .cancelled)
            default:
                loginContinuation?.resume(returning: .failure(.authorizationFailed(error)))
            }
        } else {
            loginContinuation?.resume(returning: .failure(.authorizationFailed(error)))
        }
        
        loginContinuation = nil
    }
}
