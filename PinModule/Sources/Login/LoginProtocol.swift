//
//  LoginProtocol.swift
//  app
//
//  Created by pinyi Li on 2024/12/13.
//  Copyright © 2024 yoku. All rights reserved.
//

import UIKit
import PinNetwork

public enum LoginPlatform: Int, Codable {
    case apple
    case google
}

public struct LoginInfo {
    public init(token: String, name: String?) {
        self.token = token
        self.name = name
    }
    public let token: String
    public let name: String?
}

public enum LoginResult {
    case success(LoginInfo)
    case failure(LoginError)
    case cancelled
}

public enum LoginError: Error {
    case tokenNotFound
    case authorizationFailed(Error)
    case networkError(Error)
    case unknown(String)
}

public protocol LoginProtocol {
    var platform: LoginPlatform { get }

    @MainActor
    func login() async -> LoginResult
}

