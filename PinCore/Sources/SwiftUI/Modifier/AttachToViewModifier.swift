//
//  AttachToViewModifier.swift
//  PinKit
//
//  Created by pinyi Li on 2025/6/10.
//

import SwiftUI

public enum ArrowDirection {
    case top
    case bottom
    case left
    case right
}

public struct AttachToViewModifier: ViewModifier {
    // MARK: Public

    public init(targetView: UIView, screenSize: CGSize, contentSize: CGSize, arrowDirection: ArrowDirection, alignment: Alignment, offset: CGSize, margin: CGFloat = 8) {
        self.targetView = targetView
        self.screenSize = screenSize
        self.contentSize = contentSize
        self.arrowDirection = arrowDirection
        self.alignment = alignment
        self.offset = offset
        self.margin = margin
    }

    public func body(content: Content) -> some View {
        let window = UIApplication.shared.keyWindowCompact
        let focusFrame = targetView.convert(targetView.bounds, to: window)
        let position = calculatePosition(focusFrame: focusFrame, contentSize: contentSize)

        content
            .position(position)
    }

    // MARK: Internal

    let targetView: UIView
    let screenSize: CGSize
    let contentSize: CGSize
    let arrowDirection: ArrowDirection
    let alignment: Alignment
    let offset: CGSize
    let margin: CGFloat // 邊界間距

    // MARK: Private

    private func calculatePosition(focusFrame: CGRect, contentSize: CGSize) -> CGPoint {
        var x: CGFloat = focusFrame.midX
        var y: CGFloat = focusFrame.midY

        switch arrowDirection {
        case .top:
            y = focusFrame.minY - contentSize.height / 2 - margin
        case .bottom:
            y = focusFrame.maxY + contentSize.height / 2 + margin
        case .left:
            x = focusFrame.minX - contentSize.width / 2 - margin
        case .right:
            x = focusFrame.maxX + contentSize.width / 2 + margin
        }

        switch alignment {
        case .leading:
            x = focusFrame.minX + contentSize.width / 2
        case .trailing:
            x = focusFrame.maxX - contentSize.width / 2
        case .top:
            y = focusFrame.minY + contentSize.height / 2
        case .bottom:
            y = focusFrame.maxY - contentSize.height / 2
        default:
            break
        }

        x += offset.width
        y += offset.height

        // 確保不超出螢幕邊界
        let minX = contentSize.width / 2 + margin
        let maxX = screenSize.width - contentSize.width / 2 - margin
        let minY = contentSize.height / 2 + margin
        let maxY = screenSize.height - contentSize.height / 2 - margin

        x = min(max(x, minX), maxX)
        y = min(max(y, minY), maxY)

        return CGPoint(x: x, y: y)
    }
}
