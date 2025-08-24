//
//  View+Extension.swift
//  PinKit
//
//  Created by 李品毅 on 2025/8/24.
//

import SwiftUI

public extension View {
    /// 全螢幕顯示多張圖片的 PhotoPagerView
    func fullScreenPhotoPager(isPresented: Binding<Bool>,
                              imageUrls: [String],
                              startIndex: Int = 0) -> some View {
        fullScreenCover(isPresented: isPresented) {
            let sources: [PhotoSource] = imageUrls
                .compactMap { URL(string: $0) }
                .map { .url($0) }

            if !sources.isEmpty {
                PhotoPagerView(sources: sources, index: startIndex)
                    .background(BackgroundClearView())
                    .transition(.opacity)
            }
        }
    }
}
