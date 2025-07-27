//
//  GoogleManager.swift
//  app
//
//  Created by 賀華 on 2024/7/16.
//  Copyright © 2024 yoku. All rights reserved.
//

import GoogleSignIn
import UIKit

public struct GoogleManager: LoginProtocol {
    // MARK: Internal

    public let platform: LoginPlatform = .google

    @MainActor
    public func login() async -> LoginResult {
        guard let topVC = UIApplication.shared.getTopViewController() else {
            return .failure(.unknown("No top view controller available"))
        }

        return await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { signInResult, error in
                if let error {
                    // Check if user cancelled the sign in
                    let nsError = error as NSError
                    if nsError.domain == "com.google.GIDSignIn" && nsError.code == -5 {
                        continuation.resume(returning: .cancelled)
                    } else {
                        continuation.resume(returning: .failure(.authorizationFailed(error)))
                    }
                    return
                }

                guard let signInResult,
                      let googleToken = signInResult.user.idToken?.tokenString
                else {
                    continuation.resume(returning: .failure(.tokenNotFound))
                    return
                }

                let name = self.getName(signInResult)
                let loginInfo = LoginInfo(token: googleToken, name: name)
                continuation.resume(returning: .success(loginInfo))
            }
        }
    }

    // MARK: Private

    private func getName(_ signInResult: GIDSignInResult) -> String? {
        if let profile = signInResult.user.profile {
            return (profile.familyName ?? "") + (profile.givenName ?? "")
        } else {
            return nil
        }
    }
}
