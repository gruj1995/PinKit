//
//  Shared+Extension.swift
//  
//
//  Created by pinyi Li on 2024/7/15.
//

import UIKit

public extension Collection {
    /// Accesses the element at the specified index if it is within bounds, otherwise returns nil.
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index if it is within bounds; otherwise, nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

public extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    /// 取得前一個選項
    func previous() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        return previous < all.startIndex ? all[all.index(before: all.endIndex)] : all[previous]
    }

    /// 取得後一個選項
    func next() -> Self? {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return (next == all.endIndex) ? all[all.startIndex] : all[next]
    }
}

public extension Optional where Wrapped: Collection {
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Error {
    /// 如果是自訂的錯誤，印出對應的 errorDescription
    var unwrapDescription: String {
        if let localizedError = self as? LocalizedError {
            return localizedError.errorDescription ?? localizedError.localizedDescription
        } else {
            return localizedDescription
        }
    }
}

public extension URLComponents {
    mutating func setQueryItems(params: [String: String]) {
        queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
