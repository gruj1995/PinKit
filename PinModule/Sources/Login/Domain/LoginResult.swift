//
//  LoginResult.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import Foundation

public enum LoginResult: Equatable {
    case success(LoginCredential)
    case failure(LoginError)
    case cancelled
}

public enum LoginError: Error, Equatable {
    case tokenNotFound
    case authorizationFailed(String)
    case networkError(String)
    case unknown(String)
    
    public var localizedDescription: String {
        switch self {
        case .tokenNotFound:
            return "無法取得驗證權杖"
        case .authorizationFailed(let message):
            return "授權失敗: \(message)"
        case .networkError(let message):
            return "網路錯誤: \(message)"
        case .unknown(let message):
            return "未知錯誤: \(message)"
        }
    }
}