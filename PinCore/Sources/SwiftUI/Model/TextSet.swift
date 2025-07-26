//
//  TextSet.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/22.
//

import SwiftUI

public struct TextSet {
    // MARK: Lifecycle

    public init(text: String, font: Font, color: Color) {
        self.text = text
        self.font = font
        self.color = color
    }

    // MARK: Internal

    public var text: String
    public var font: Font
    public var color: Color
}
