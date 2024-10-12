//
//  APIService.swift
//  app
//
//  Created by pinyi Li on 2024/4/12.
//  Copyright © 2024 pinyi Li All rights reserved.
//

import Moya

public class APIService: APIServiceProtocol {
    public static let shared = APIService()

    public let provider = MoyaProvider<MultiTarget>()

    public func request(_ request: TargetType, completion: @escaping (_ result: Result<Moya.Response, Error>) -> Void) {
        let target = MultiTarget(request)

        // TODO: 是否該設置 validStatusCode = 200 ..< 300
        provider.request(target) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func asyncRequest(_ request: Moya.TargetType) async throws -> Moya.Response {
        let target = MultiTarget(request)

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func decodeRequest<T: DecodableTargetType>(_ request: T, completion: @escaping (_ result: Result<T.ResultType, MoyaError>) -> Void) {
        let target = MultiTarget(request)

        provider.request(target) { result in
            switch result {
            case .success(let response):
                if let model = try? response.map(T.ResultType.self) {
                    completion(.success(model))
                } else {
                    completion(.failure(.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func asyncDecodeRequest<T: DecodableTargetType>(_ request: T) async throws -> T.ResultType {
        let target = MultiTarget(request)

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    guard let res = try? response.map(T.ResultType.self) else {
                        continuation.resume(throwing: MoyaError.jsonMapping(response))
                        return
                    }
                    continuation.resume(returning: res)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

//    func requestDecodedPublisher<T: DecodableTargetType>(_ request: T) -> AnyPublisher<T.ResultType, MoyaError> {
//        let target = MultiTarget(request)
//        return provider.requestPublisher(target)
//            .map(\.data)
//            .decode(type: T.ResultType.self, decoder: JSONDecoder())
//            .mapError { error in
//                MoyaError.underlying(error, nil)
//            }
//            .eraseToAnyPublisher()
//    }
}
