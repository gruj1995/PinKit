//
//  LoginPlatform.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import Foundation

public enum LoginPlatform: String, Codable, CaseIterable, Identifiable {
    case apple = "apple"
    case google = "google"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        }
    }
    
    public var icon: AppImage {
        switch self {
        case .apple: return .logoApple
        case .google: return .logoGoogle
        }
    }
}
