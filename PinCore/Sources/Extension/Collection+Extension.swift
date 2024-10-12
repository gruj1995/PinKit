//
//  Collection+Extension.swift
//
//
//  Created by 李品毅 on 2023/11/3.
//

import Foundation

public extension Collection {
    /// Accesses the element at the specified index if it is within bounds, otherwise returns nil.
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index if it is within bounds; otherwise, nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Optional where Wrapped: Collection {

    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }

    mutating func appendAndSetIfNil<E>(_ element: Wrapped.Element) where Wrapped == [E] {
        self = (self ?? []) + [element]
    }

    mutating func appendAndSetIfNil<S>(contentsOf newElements: S) where S: Sequence, Wrapped == [S.Element] {
        self = (self ?? []) + newElements
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
