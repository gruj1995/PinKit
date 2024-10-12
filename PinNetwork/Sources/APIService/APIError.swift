//
//  APIError.swift
//  
//
//  Created by pinyi Li on 2024/7/22.
//

import Foundation

public enum APIError: LocalizedError {
    case decodingFailed
    case nilData
    case missingRequiredParameters
    case customMessage(String)
    case codeMessage(Int, String?, Error?)

    // MARK: Internal

    public var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Data decoding failed."
        case .nilData:
            return "Received nil data."
        case .missingRequiredParameters:
            return "Required parameters are missing."
        case .customMessage(let message):
            return message
        case .codeMessage(let statusCode, let requestId, let error):
            return "\(statusCode): requestId-\(requestId) \(error?.localizedDescription ?? "")"
        }
    }
}

