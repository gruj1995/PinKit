//
//  AuthRepository.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import Foundation

public protocol AuthRepositoryProtocol {
    func loginWithApple() async -> LoginResult
    func loginWithGoogle() async -> LoginResult
    func logout() async throws
}

public final class AuthRepository: AuthRepositoryProtocol {
    
    private let appleDataSource: AppleAuthDataSource
    private let googleDataSource: GoogleAuthDataSource
    
    public init(
        appleDataSource: AppleAuthDataSource,
        googleDataSource: GoogleAuthDataSource
    ) {
        self.appleDataSource = appleDataSource
        self.googleDataSource = googleDataSource
    }
    
    public func loginWithApple() async -> LoginResult {
        await appleDataSource.signIn()
    }
    
    public func loginWithGoogle() async -> LoginResult {
        await googleDataSource.signIn()
    }
    
    public func logout() async throws {
        // Implement logout logic if needed
        // This could involve calling API endpoints, clearing local storage, etc.
    }
}