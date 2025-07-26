//
//  BackgroundClearView.swift
//  PinKit
//
//  Created by 賀華 on 2025/3/10.
//

import SwiftUI

public struct BackgroundClearView: UIViewRepresentable {
    public init() {}
    public func makeUIView(context _: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_: UIView, context _: Context) {}
}
