//
//  ShakeModifier.swift
//  PinKit
//
//  Created by pinyi Li on 2025/4/18.
//

import SwiftUI

public struct ShakeEffect: GeometryEffect {
    public var amount: CGFloat = 10
    public var shakesPerUnit = 3
    public var animatableData: CGFloat

    public func effectValue(size _: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: sin(animatableData * .pi * CGFloat(shakesPerUnit)) * amount,
            y: 0
        ))
    }
}

public struct ShakeModifier: ViewModifier {
    // MARK: Internal

    public let trigger: Bool
    public let force: CGFloat
    public let duration: Double
    public let repeatCount: Int

    public func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(amount: 30 * force, shakesPerUnit: 3, animatableData: CGFloat(shakeTimes)))
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    withAnimation(.easeOut(duration: duration)) {
                        shakeTimes += repeatCount
                    }
                }
            }
    }

    // MARK: Private

    @State private var shakeTimes: Int = 0
}

public extension View {
    func shake(trigger: Bool,
               force: CGFloat = 0.2,
               duration: Double = 0.5,
               repeatCount: Int = 1) -> some View {
        modifier(ShakeModifier(trigger: trigger, force: force, duration: duration, repeatCount: repeatCount))
    }
}
