//
//  UserDefaultValue.swift
//  
//
//  Created by 李品毅 on 2023/7/14.
//

import Combine
import Foundation

// 參考文章： https://www.avanderlee.com/swift/property-wrappers/

@propertyWrapper
public struct UserDefaultValue<Value: Codable> {
    // MARK: Lifecycle

    public init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }

    // MARK: Public

    public let key: String

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

    // MARK: Internal

    let defaultValue: Value

    // 外部可以替換預設的 UserDefaults 容器，比如透過 UserDefaults(suiteName: "group.com.squareMusic.app") 生成
    let container: UserDefaults

    // MARK: Private

    private let publisher = PassthroughSubject<Value, Never>()

    private func get<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = container.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func set(_ value: (some Encodable)?, forKey key: String) {
        if let value {
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
