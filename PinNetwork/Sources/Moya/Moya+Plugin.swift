//
//  Moya+Plugin.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/9.
//

import Moya

public final class StatusCodePlugin: PluginType {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public func process(_ result: Result<Response, MoyaError>, target _: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            guard (200 ... 299).contains(response.statusCode) else {
                return .failure(MoyaError.statusCode(response))
            }
            return .success(response)
        case .failure(let error):
            return .failure(error)
        }
    }
}
