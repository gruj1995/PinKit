//
//  DecodableTargetType.swift
//  app
//
//  Created by pinyi Li on 2024/4/12.
//  Copyright © 2024 pinyi Li All rights reserved.
//

import Moya

public typealias Parameters = [String: Any]

public protocol DecodableTargetType: TargetType {
    associatedtype ResultType: Decodable

    var parameters: Parameters? { get }

    var encoding: ParameterEncoding { get }
}
