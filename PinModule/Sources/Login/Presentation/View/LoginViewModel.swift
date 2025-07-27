//
//  LoginViewModel.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import Foundation
import Observation

@MainActor
@Observable
public final class LoginViewModel {
    // MARK: Lifecycle

    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    // MARK: Public

    public var isAppleLoading = false
    public var isGoogleLoading = false
    public var errorMessage: String?
    public var showError = false
    public var loginCredential: LoginCredential?
    public var isAuthenticated = false

    public var isLoading: Bool {
        isAppleLoading || isGoogleLoading
    }

    public func loginWithApple() async {
        isAppleLoading = true
        defer { isAppleLoading = false }

        let result = await authRepository.loginWithApple()
        await handleLoginResult(result)
    }

    public func loginWithGoogle() async {
        isGoogleLoading = true
        defer { isGoogleLoading = false }

        let result = await authRepository.loginWithGoogle()
        await handleLoginResult(result)
    }

    public func logout() async {
        do {
            try await authRepository.logout()
            loginCredential = nil
            isAuthenticated = false
        } catch {
            showErrorMessage(error.localizedDescription)
        }
    }

    public func clearError() {
        errorMessage = nil
        showError = false
    }

    // MARK: Private

    private let authRepository: AuthRepositoryProtocol

    private func handleLoginResult(_ result: LoginResult) async {
        switch result {
        case .success(let credential):
            loginCredential = credential
            isAuthenticated = true

        case .failure(let error):
            showErrorMessage(error.localizedDescription)

        case .cancelled:
            // User cancelled, no action needed
            break
        }
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
