//
//  GIFImageView.swift
//  PinKit
//
//  Created by pinyi Li on 2025/5/16.
//

import Kingfisher
import SwiftUI

public struct GIFImageView: View {
    // MARK: Lifecycle

    public init(source: Source) {
        self.source = source
    }

    // MARK: Public

    public enum Source {
        case remote(URL)
        case local(String) // 本地檔案名稱，不含副檔名
    }

    public var body: some View {
        content
    }

    // MARK: Private

    private let source: Source

    @ViewBuilder
    private var content: some View {
        switch source {
        case .remote(let url):
            KFAnimatedImage(url)
                .cacheMemoryOnly()

        case .local(let name):
            if let url = Bundle.resourceURL(named: name, extension: "gif", fallback: .module) {
                let provider = LocalFileImageDataProvider(fileURL: url)
                KFAnimatedImage(source: .provider(provider))
            } else {
                Text("找不到本地檔案 \(name).gif")
            }
        }
    }
}

#Preview {
    GIFImageView(source: .local("example"))
}
