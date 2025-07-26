//
//  PhotoPagerView.swift
//  PinKit
//
//  Created by 李品毅 on 2025/5/14.
//

import SwiftUI
import PinCore

public enum PhotoSource {
    case url(URL)
    case uiImage(UIImage)
    case image(Image)
}

public struct PhotoPagerView: View {
    // MARK: Lifecycle

    public init(sources: [PhotoSource], index: Int = 0) {
        self.sources = sources
        _currentIndex = State(initialValue: index)
    }

    // MARK: Public

    public var onTapPage: ((Int) -> Void)?
    public var onPageChanged: ((Int) -> Void)?
    public var onImageAppear: ((PhotoSource) -> Void)?

    public var body: some View {
        GeometryReader { geometry in
            LazyPager(data: sources, page: $currentIndex) { source in
                imageView(for: source)
                    .aspectRatio(contentMode: .fit)
            }
            .zoomable(min: 1, max: 5)
            .onTap {
                onTapPage?(currentIndex)
            }
            .onPageChanged { index in
                onPageChanged?(index)
                onImageAppear?(sources[index])
            }
            .offset(x: dragOffset.width, y: dragOffset.height)
            .scaleEffect(currentScale)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        let progress = abs(value.translation.height) / dismissThreshold
                        backgroundOpacity = 1.0 - min(progress, 1.0)
                        // Scale from 1.0 down to 0.5 based on drag progress
                        currentScale = 1.0 - (min(progress, 1.0) * 0.5)
                    }
                    .onEnded { value in
                        let velocity = value.predictedEndTranslation.height - value.translation.height
                        if abs(dragOffset.height) > dismissThreshold || abs(velocity) > velocityThreshold {
                            dismiss()
                        } else {
                            withAnimation(.spring()) {
                                dragOffset = .zero
                                backgroundOpacity = 1.0
                                currentScale = 1.0
                            }
                        }
                    }
            )
        }
        .background(Color.black.opacity(backgroundOpacity).ignoresSafeArea())
        .overlay(closeButton, alignment: .topTrailing)
        .overlay(pageIndicator, alignment: .bottom)
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var backgroundOpacity: Double = 1.0
    @State private var currentScale: CGFloat = 1.0
    
    private let dismissThreshold: CGFloat = 100
    private let velocityThreshold: CGFloat = 300
    private let sources: [PhotoSource]

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 28))
                .foregroundColor(.white)
                .padding()
        }
    }

    private var pageIndicator: some View {
        Text(verbatim: "\(currentIndex + 1)/\(sources.count)")
            .font(.system(size: 13))
            .foregroundColor(.white)
            .padding(.bottom, 20)
    }

    @ViewBuilder
    private func imageView(for source: PhotoSource) -> some View {
        switch source {
        case .url(let url):
            KingfisherImageView(imagePath: url.absoluteString)
        case .uiImage(let image):
            Image(uiImage: image)
                .resizable()
        case .image(let image):
            image
                .resizable()
        }
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
    PhotoPagerView(sources: mockImagePaths.compactMap { path in
        guard let url = URL(string: path) else { return nil }
        return .url(url)
    })
}
