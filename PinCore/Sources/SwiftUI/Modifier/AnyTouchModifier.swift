//
//  AnyTouchModifier.swift
//  PinKit
//
//  Created by pinyi Li on 2025/4/18.
//

import SwiftUI

public struct AnyTouchModifier: ViewModifier {
    public let onTouch: () -> Void

    public func body(content: Content) -> some View {
        content
            .contentShape(Rectangle()) // 確保整個範圍可觸控
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        onTouch()
                    }
            )
    }
}

public extension View {
    func onAnyTouch(perform action: @escaping () -> Void) -> some View {
        modifier(AnyTouchModifier(onTouch: action))
    }
}
