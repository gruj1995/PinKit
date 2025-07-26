//
//  KingfisherImageView.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/16.
//

import Kingfisher
import SwiftUI

public struct KingfisherImageView<Placeholder: View>: View {
    // MARK: Lifecycle

    public init(imagePath: String,
                imageCornerRadius: CGFloat = 0,
                imageContentMode: ImageContentMode = .scaleToFill,
                aspectRatio: CGFloat? = nil,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                @ViewBuilder placeholder: @escaping () -> Placeholder = { ProgressView() }) {
        self.imagePath = imagePath
        self.imageCornerRadius = imageCornerRadius
        self.imageContentMode = imageContentMode
        self.aspectRatio = aspectRatio
        self.width = width
        self.height = height
        self.placeholder = placeholder
    }

    public init(url: URL?,
                imageCornerRadius: CGFloat = 0,
                imageContentMode: ImageContentMode = .scaleToFill,
                aspectRatio: CGFloat? = nil,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                @ViewBuilder placeholder: @escaping () -> Placeholder = { ProgressView() }) {
        self.init(
            imagePath: url?.absoluteString ?? "",
            imageCornerRadius: imageCornerRadius,
            imageContentMode: imageContentMode,
            aspectRatio: aspectRatio,
            width: width,
            height: height,
            placeholder: placeholder
        )
    }

    // MARK: Public

    public let imagePath: String
    public var onSuccess: ((KFCrossPlatformImage) -> Void)?
    @ViewBuilder public var placeholder: () -> Placeholder

    public var body: some View {
        content
    }

    // MARK: Private

    /// 在圖片載入時，直接在 Kingfisher 處理階段把圖片變成圓角或圓形
    private let imageCornerRadius: CGFloat
    private let imageContentMode: ImageContentMode
    private let aspectRatio: CGFloat?
    private let width: CGFloat?
    private let height: CGFloat?

    @ViewBuilder
    private var content: some View {
        let image = KFImage(URL(string: imagePath))
            .placeholder { placeholder() }
            .roundCorner(radius: .point(imageCornerRadius))
            .onSuccess { result in onSuccess?(result.image) }
            .cancelOnDisappear(true)
            .serialize(as: .PNG)

        if let width, let height {
            image.contentMode(imageContentMode, width: width, height: height)
        } else {
            image.contentMode(imageContentMode)
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(ImageContentMode.allCases, id: \.self) { mode in
                VStack {
                    Text(mode.rawValue)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    KingfisherImageView(
                        url: URL(string: "https://media.vogue.com.tw/photos/6038d92dd94ee12bf6c6a5dc/master/w_1600%2Cc_limit/nd-life-map_num.jpg"),
                        imageCornerRadius: 12,
                        imageContentMode: mode,
                        width: 200,
                        height: 150
                    )
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
    }
}
