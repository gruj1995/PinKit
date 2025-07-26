//
//  Color+Extension.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/26.
//

import SwiftUI

public extension Color {
    init(hex: String, fallback: Color = .clear) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)

        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        guard hexString.count == 6,
              let hexNumber = UInt64(hexString, radix: 16) else {
            self = fallback
            return
        }

        let red = Double((hexNumber >> 16) & 0xFF) / 255
        let green = Double((hexNumber >> 8) & 0xFF) / 255
        let blue = Double(hexNumber & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }

    var hexString: String? {
        let uiColor = UIColor(self)
        return uiColor.hexString
    }
}
