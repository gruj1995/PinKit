//
//  LoginCredential.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import Foundation

public struct LoginCredential: Codable, Identifiable, Hashable {
    // MARK: Lifecycle

    public init(platform: LoginPlatform,
                token: String,
                name: String? = nil,
                email: String? = nil) {
        self.platform = platform
        self.token = token
        self.name = name
        self.email = email
    }

    // MARK: Public

    public let id = UUID()
    public let platform: LoginPlatform
    public let token: String
    public let name: String?
    public let email: String?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case platform
        case token
        case name
        case email
    }
}
