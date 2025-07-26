//
//  TrailingIconLabelStyle.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/21.
//

import SwiftUI

public struct TrailingIconLabelStyle: LabelStyle {
    // MARK: Lifecycle

    public init(spacing: CGFloat = 4) {
        self.spacing = spacing
    }

    // MARK: Public

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.title
            configuration.icon
        }
    }

    // MARK: Internal

    let spacing: CGFloat
}

public extension LabelStyle where Self == TrailingIconLabelStyle {
    @MainActor @preconcurrency
    static var iconTrailing: TrailingIconLabelStyle { TrailingIconLabelStyle() }
}

#Preview {
    Label {
        Text("aa")
            .font(.system(size: 14))
            .foregroundColor(.blue)
    } icon: {
        Image(uiImage: .add)
            .renderingMode(.template)
            .resizable()
            .frame(width: 14, height: 14)
            .foregroundColor(.green)
    }
    .labelStyle(.iconTrailing)
}
