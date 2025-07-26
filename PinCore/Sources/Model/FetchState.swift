//
//  FetchState.swift
//  PinKit
//
//  Created by 李品毅 on 2025/7/26.
//

import Foundation

public enum FetchState: Equatable {
    case loading
    case success
    case failed(error: Error)
    case idle

    // MARK: Internal

    public static func == (lhs: FetchState, rhs: FetchState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
             (.success, .success),
             (.idle, .idle):
            return true
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
