//
//  InfiniteCarouselActions.swift
//  PinKit
//
//  Created by 李品毅 on 2025/5/28.
//

import SwiftUI

public struct InfiniteCarouselActions {
    // MARK: Lifecycle

    public init(onShowItem: ((Int) -> Void)? = nil,
                onPageChanged: ((Int) -> Void)? = nil,
                onSwipeItem: ((Int) -> Void)? = nil,
                onTapItem: ((Int) -> Void)? = nil) {
        self.onShowItem = onShowItem
        self.onPageChanged = onPageChanged
        self.onSwipeItem = onSwipeItem
        self.onTapItem = onTapItem
    }

    // MARK: Internal

    // 放在 .onAppear 初始化渲染完成
    var onShowItem: ((Int) -> Void)?
    var onSwipeItem: ((Int) -> Void)?
    var onTapItem: ((Int) -> Void)?
    var onPageChanged: ((Int) -> Void)?
}

private struct InfiniteCarouselActionKey: EnvironmentKey {
    static let defaultValue = InfiniteCarouselActions()
}

public extension EnvironmentValues {
    var infiniteCarouselActions: InfiniteCarouselActions {
        get { self[InfiniteCarouselActionKey.self] }
        set { self[InfiniteCarouselActionKey.self] = newValue }
    }
}
