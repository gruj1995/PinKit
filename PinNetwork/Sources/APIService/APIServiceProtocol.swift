//
//  APIServiceProtocol.swift
//  app
//
//  Created by pinyi Li on 2024/4/15.
//  Copyright © 2024 pinyi Li All rights reserved.
//

import Moya

public protocol APIServiceProtocol {
    var provider: MoyaProvider<MultiTarget> { get }

    func request(_ request: TargetType, completion: @escaping (_ result: Result<Moya.Response, Error>) -> Void)

    @discardableResult
    func asyncRequest(_ request: TargetType) async throws -> Moya.Response

    // MARK: - DecodeRequest

    func decodeRequest<T: DecodableTargetType>(_ request: T, completion: @escaping (_ result: Result<T.ResultType, MoyaError>) -> Void)

    func asyncDecodeRequest<T: DecodableTargetType>(_ request: T) async throws -> T.ResultType
}
