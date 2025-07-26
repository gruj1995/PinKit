//
//  KFImageContentMode.swift
//  PinKit
//
//  Created by pinyi Li on 2025/5/29.
//

import Kingfisher
import SwiftUI

public extension KFImage {
    /// Apply content mode with fixed width and height
    /// - Parameters:
    ///   - contentMode: The content mode to apply
    ///   - width: The width of the frame
    ///   - height: The height of the frame
    /// - Returns: Modified Image view
    @ViewBuilder
    func contentMode(_ contentMode: ImageContentMode, width: CGFloat, height: CGFloat) -> some View {
        switch contentMode {
        case .scaleToFill:
            resizable()
                .frame(width: width, height: height)

        case .scaleAspectFit:
            resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)

        case .scaleAspectFill:
            resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipped()

        case .center:
            frame(width: width, height: height, alignment: .center)

        case .top:
            frame(width: width, height: height, alignment: .top)

        case .bottom:
            frame(width: width, height: height, alignment: .bottom)

        case .left:
            frame(width: width, height: height, alignment: .leading)

        case .right:
            frame(width: width, height: height, alignment: .trailing)

        case .topLeft:
            frame(width: width, height: height, alignment: .topLeading)

        case .topRight:
            frame(width: width, height: height, alignment: .topTrailing)

        case .bottomLeft:
            frame(width: width, height: height, alignment: .bottomLeading)

        case .bottomRight:
            frame(width: width, height: height, alignment: .bottomTrailing)
        }
    }

    /// Apply content mode without setting size
    /// - Parameter contentMode: The content mode to apply
    /// - Returns: Modified Image view
    @ViewBuilder
    func contentMode(_ contentMode: ImageContentMode) -> some View {
        switch contentMode {
        case .scaleToFill:
            resizable()

        case .scaleAspectFit:
            resizable()
                .aspectRatio(contentMode: .fit)

        case .scaleAspectFill:
            resizable()
                .aspectRatio(contentMode: .fill)

        default:
            self
        }
    }
}
