//
//  RangeReplaceableCollectionExtension.swift
//  
//
//  Created by 李品毅 on 2023/7/19.
//

import Foundation

// https://stackoverflow.com/questions/46519004/can-somebody-give-a-snippet-of-append-if-not-exists-method-in-swift-array

public extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }

    mutating func appendIfNotContains(_ elements: [Element]) {
        elements.forEach { appendIfNotContains($0) }
    }

    @discardableResult
    mutating func insertIfNotContains(_ element: Element, at index: Index) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            insert(element, at: index)
            return (true, element)
        }
    }
}
