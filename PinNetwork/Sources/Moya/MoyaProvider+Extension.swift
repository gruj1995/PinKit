//
//  MoyaProvider+Extension.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/9.
//

import Foundation
import Moya

public extension JSONDecoder {
    static let iso8601: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    /// 支援兩種日期格式解析
    /// 1. 標準 ISO8601: "2025-07-06T00:00:08Z"
    /// 2. 微秒 ISO8601: "2025-07-02T08:00:38.093839Z"
    static let mixedISO8601: JSONDecoder = {
        let decoder = JSONDecoder()

        let standardFormatter = ISO8601DateFormatter()
        standardFormatter.formatOptions = [.withInternetDateTime]
        
        let microsecondsFormatter = ISO8601DateFormatter()
        microsecondsFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()

            guard let raw = try? container.decode(String.self) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "日期必須是字符串類型"
                    )
                )
            }
            
            // 快速判斷：基於是否包含小數點
            if raw.contains(".") {
                // 微秒格式
                if let date = microsecondsFormatter.date(from: raw) {
                    return date
                }
            } else {
                // 標準格式
                if let date = standardFormatter.date(from: raw) {
                    return date
                }
            }

            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "無法解析日期格式: '\(raw)'"
                )
            )
        }
        return decoder
    }()
}

public extension MoyaProvider {
    @discardableResult
    func request(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    if (200 ..< 300).contains(response.statusCode) {
                        continuation.resume(returning: response)
                    } else {
                        continuation.resume(throwing: MoyaError.statusCode(response))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @discardableResult
    func decodeRequest<T: Decodable>(_ target: Target,
                                     decoder: JSONDecoder = .mixedISO8601) async throws -> T {
        let response = try await request(target)
        return try response.map(T.self, using: decoder)
    }
}
