//
//  InfiniteCarouselView.swift
//  PinKit
//
//  Created by 賀華 on 2025/4/28.
//

import SwiftUI

public struct InfiniteCarouselView<Content: View>: View {
    // MARK: Lifecycle

    public init(views: [Content],
                itemSize: CGSize? = nil,
                spacing: CGFloat,
                autoScrollInterval: TimeInterval = 3.0,
                autoScrollEnabled: Bool = true,
                gestureEnabled: Bool = true,
                threshold: CGFloat = 50,
                isVisible: Binding<Bool> = .constant(true)) {
        self.views = views.enumerated().map { index, view in
            (index, view)
        }
        repeatedViews = self.views + self.views + self.views
        baseIndex = self.views.count
        self.itemSize = itemSize
        self.spacing = spacing
        self.autoScrollInterval = autoScrollInterval
        self.autoScrollEnabled = autoScrollEnabled
        self.gestureEnabled = gestureEnabled
        self.threshold = threshold
        _isVisible = isVisible
    }

    // MARK: Public

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                let effectiveItemSize = getEffectiveItemSize(from: geometry)

                ForEach(0 ..< repeatedViews.count, id: \.self) { index in
                    carouselItem(
                        at: index,
                        effectiveItemSize: effectiveItemSize
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(gestureEnabled ? dragGesture : nil)
            // 避免 drag, tap 手勢衝突
            .simultaneousGesture(tapGesture)
        }
        .onAppear {
            if autoScrollEnabled, isVisible {
                startAutoScroll()
            }

            // 第一個banner事件
            triggerPageChangedIfNeeded()
        }
        .onDisappear(perform: stopAutoScroll)
        .onChange(of: currentIndex) { _ in
            triggerPageChangedIfNeeded()
        }
        .onChange(of: isVisible) { isVisible in
            if autoScrollEnabled {
                isVisible ? startAutoScroll() : stopAutoScroll()
            }
        }
    }

    // MARK: Private

    @State private var currentIndex = 0
    @State private var lastCurrentIndex: Int?

    @State private var dragOffset: CGFloat = 0
    @State private var timer: Timer?

    @Binding private var isVisible: Bool
    @Environment(\.infiniteCarouselActions) private var actions

    private let views: [(index: Int, view: Content)]
    private let repeatedViews: [(index: Int, view: Content)]
    private let baseIndex: Int
    private let itemSize: CGSize?
    private let spacing: CGFloat
    private let autoScrollInterval: TimeInterval
    private let autoScrollEnabled: Bool
    private let gestureEnabled: Bool
    private let threshold: CGFloat

    // MARK: - Gesture Methods

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                let actualIndex = getActualCurrentIndex()
                actions.onTapItem?(actualIndex)
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
                stopAutoScroll()
            }
            .onEnded(handleDragEnd)
    }

    private func carouselItem(at index: Int, effectiveItemSize: CGSize) -> some View {
        let isCenterItem = index == getRealIndex()
        let isInCenter = isInCenterGroup(index)
        let originalIndex = repeatedViews[index].index
        let view = repeatedViews[index].view

        let offset = CGFloat(index - getRealIndex()) * (effectiveItemSize.width + spacing) + dragOffset

        return view
            .frame(width: effectiveItemSize.width, height: effectiveItemSize.height)
            .clipped()
            .offset(x: offset)
            .zIndex(isCenterItem ? 1 : 0)
            .animation(.spring(), value: dragOffset)
            .onAppear {
                if isInCenter, isVisible {
                    actions.onShowItem?(originalIndex)
                }
            }
    }

    private func triggerPageChangedIfNeeded() {
        let actualCurrentIndex = getActualCurrentIndex()
        if lastCurrentIndex != actualCurrentIndex {
            lastCurrentIndex = actualCurrentIndex
            actions.onPageChanged?(actualCurrentIndex)
        }
    }

    private func getRealIndex() -> Int {
        currentIndex + baseIndex
    }

    /// 判斷給定的 index 是否位於「中間那組原始 views」的範圍內。
    /// repeatedViews 是由 [views + views + views] 組成的三組結構，
    /// 為了實作 infinite scroll，實際顯示的中心 group 是中間那組。
    /// baseIndex 是中間那組的起始 index。
    /// 若 index 落在這段範圍，就表示目前這個項目是使用者實際在看的 group。
    private func isInCenterGroup(_ index: Int) -> Bool {
        index >= baseIndex && index < baseIndex + views.count
    }

    private func getActualCurrentIndex() -> Int {
        (currentIndex + views.count) % views.count
    }

    private func getEffectiveItemSize(from geometry: GeometryProxy) -> CGSize {
        itemSize ?? CGSize(
            width: geometry.size.width,
            height: geometry.size.height
        )
    }

    private func handleDragEnd(_ value: DragGesture.Value) {
        let oldIndex = currentIndex

        if value.translation.width < -threshold {
            currentIndex += 1
        } else if value.translation.width > threshold {
            currentIndex -= 1
        }

        handleIndexBoundary()
        dragOffset = 0
        handleIndexSwipeChanged(oldIndex)

        if autoScrollEnabled {
            startAutoScroll()
        }
    }

    private func handleIndexBoundary() {
        if currentIndex >= views.count {
            resetToFirstItem()
        } else if currentIndex < 0 {
            resetToLastItem()
        }
    }

    private func resetToFirstItem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.none) {
                currentIndex = 0
            }
        }
    }

    private func resetToLastItem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.none) {
                currentIndex = views.count - 1
            }
        }
    }

    private func handleIndexSwipeChanged(_ oldIndex: Int) {
        if oldIndex != currentIndex {
            actions.onSwipeItem?(getActualCurrentIndex())
        }
    }

    // MARK: - Auto Scroll Methods

    private func startAutoScroll() {
        stopAutoScroll()

        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            withAnimation {
                currentIndex += 1
            }

            if currentIndex >= views.count {
                resetToFirstItem()
            }
        }
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

let mockImagePaths: [String] = [
    "https://cdn.cybassets.com/s/files/18929/ckeditor/pictures/content_679f61eb-3abb-46f5-bee8-00c0dc8e9725.jpg",
    "https://imgcdn.cna.com.tw/www/WebPhotos/800/20240225/2000x1333_wmkn_56954059532653_0.jpg",
    "https://orange-white.tw/wp-content/uploads/2023/10/%E8%81%96%E6%96%87_%E9%9D%9C%E5%A6%82-201-scaled.jpg",
    "https://www.hotpets.com.tw/wp-content/uploads/2024/02/%E5%B8%83%E5%81%B6%E8%B2%93-scaled-e1706757921857.jpg",
    "https://s.yimg.com/ny/api/res/1.2/v2ics1Z_DbOFT6wrjTaxGw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTY0MDtoPTQyNw--/https://s.yimg.com/os/creatr-uploaded-images/2022-06/3757bb00-eca8-11ec-bf3f-7c2b69f1b53a"
]

#Preview {
    let views = mockImagePaths.enumerated().map { _, urlString in
        KingfisherImageView(imagePath: urlString)
            .aspectRatio(contentMode: .fill)
            .clipped()
    }

    InfiniteCarouselView(views: views, spacing: 0)
        .environment(\.infiniteCarouselActions, .init(
            onShowItem: { index in
                PinLogger.log("\(index) show")
            },
            onSwipeItem: { index in
                PinLogger.log("\(index) show")
            },
            onTapItem: { index in
                PinLogger.log("\(index) show")
            }
        ))
        .aspectFitHeight(132.0 / 375.0)
}
