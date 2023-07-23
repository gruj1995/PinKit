//
//  UserDefaultValue.swift
//  
//
//  Created by 李品毅 on 2023/7/14.
//

import Foundation
import Combine

// 參考文章： https://www.avanderlee.com/swift/property-wrappers/

@available(iOS 13.0, *)
@propertyWrapper
public struct UserDefaultValue<Value: Codable> {
    // 外部可以替換預設的 UserDefaults 容器，比如透過 UserDefaults(suiteName: "group.com.squareMusic.app") 生成
    public let container: UserDefaults = .standard

    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            get(forKey: key, as: Value.self) ?? defaultValue
        }
        set {
            set(newValue, forKey: key)
            publisher.send(newValue)
        }
    }

    // 使用投影值觀察值的變化
    public var projectedValue: AnyPublisher<Value, Never> {
        return publisher.eraseToAnyPublisher()
    }

    // MARK: private

    private let key: String
    private let defaultValue: Value
    private let publisher = PassthroughSubject<Value, Never>()

    private func get<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = container.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func set<T: Encodable>(_ value: T?, forKey key: String) {
        if let value = value {
            if let data = try? JSONEncoder().encode(value) {
                container.set(data, forKey: key)
            } else {
                container.set(nil, forKey: key)
            }
        } else {
            container.set(nil, forKey: key)
        }
    }
}
