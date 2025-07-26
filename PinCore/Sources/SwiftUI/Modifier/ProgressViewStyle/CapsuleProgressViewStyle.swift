//
//  CapsuleProgressViewStyle.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/23.
//

import SwiftUI

public enum ProgressShape {
    case capsule
    case rectangle(CGFloat)
}

public struct CapsuleProgressViewStyle: ProgressViewStyle {
    // MARK: Lifecycle

    public init(backgroundColor: Color,
                fillColor: Color,
                height: CGFloat,
                progressShape: ProgressShape = .rectangle(0)) {
        self.backgroundColor = backgroundColor
        self.fillColor = fillColor
        self.height = height
        self.progressShape = progressShape
    }

    // MARK: Public

    public var backgroundColor: Color
    public var fillColor: Color
    public var height: CGFloat
    public var progressShape: ProgressShape

    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        ZStack(alignment: .leading) {
            Capsule()
                .fill(backgroundColor)

            shapeView(fillColor: fillColor)
                .scaleEffect(x: progress, y: 1, anchor: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
        .clipShape(.capsule)
    }

    // MARK: Private

    @ViewBuilder
    private func shapeView(fillColor: Color) -> some View {
        switch progressShape {
        case .capsule:
            Capsule()
                .fill(fillColor)
        case .rectangle(let radius):
            RoundedRectangle(cornerRadius: radius)
                .fill(fillColor)
        }
    }
}

#Preview {
    ProgressView(value: 0.7)
        .progressViewStyle(
            CapsuleProgressViewStyle(
                backgroundColor: .gray,
                fillColor: .yellow,
                height: 24
            )
        )
        .overlay(
            Capsule()
                .stroke(.blue, lineWidth: 2)
        )
        .padding()
}
