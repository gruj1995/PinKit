//
//  GoogleAuthDataSource.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import GoogleSignIn
import UIKit
import PinCore

@MainActor
public final class GoogleAuthDataSource {
    
    public init() {}
    
    public func signIn() async -> LoginResult {
        guard let presentingViewController = UIApplication.shared.getTopViewController() else {
            return .failure(.unknown("No presenting view controller available"))
        }
        
        return await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                if let error {
                    PinLogger.log("Google Sign In Error: \(error.localizedDescription)")
                    
                    let nsError = error as NSError
                    if nsError.domain == "com.google.GIDSignIn" && nsError.code == -5 {
                        continuation.resume(returning: .cancelled)
                    } else {
                        continuation.resume(returning: .failure(.authorizationFailed(error.localizedDescription)))
                    }
                    return
                }
                
                guard let result,
                      let idToken = result.user.idToken?.tokenString else {
                    continuation.resume(returning: .failure(.tokenNotFound))
                    return
                }
                
                let profile = result.user.profile
                let name = [profile?.givenName, profile?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                    .trimmingCharacters(in: .whitespaces)
                
                let credential = LoginCredential(
                    platform: .google,
                    token: idToken,
                    name: name.isEmpty ? nil : name,
                    email: profile?.email
                )
                
                continuation.resume(returning: .success(credential))
            }
        }
    }
}
