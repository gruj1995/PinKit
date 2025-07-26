//
//  View+Extension.swift
//  PinKit
//
//  Created by 李品毅 on 2025/4/27.
//

import SwiftUI

public extension View {
    /// Sets the value of a writable property on a `View`, typically used for setting actions more fluently.
    ///
    /// This is useful for setting closures or callbacks from outside without manually copying the entire `View` struct.
    ///
    /// - Parameters:
    ///   - property: A writable key path to the property you want to modify.
    ///   - value: The new value to assign to the property.
    /// - Returns: A copy of the view with the updated property value.
    ///
    /// ## Example
    /// ```swift
    /// struct MyButtonView: View {
    ///     var onTap: (() -> Void)?
    ///
    ///     var body: some View {
    ///         Button("Tap me") {
    ///             onTap?()
    ///         }
    ///     }
    /// }
    ///
    /// // Usage
    /// MyButtonView()
    ///     .setAction(\.onTap, to: {
    ///         print("Button was tapped!")
    ///     })
    /// ```
    func setAction<Value>(_ property: WritableKeyPath<Self, Value>, to value: Value) -> Self {
        var copy = self
        copy[keyPath: property] = value
        return copy
    }

    func setLocale(_ identifier: String = "zh-Hant") -> some View {
        environment(\.locale, Locale(identifier: identifier))
    }

    func aspectFitHeight(_ aspectRatio: CGFloat) -> some View {
        let screenWidth = UIScreen.main.bounds.width
        return frame(height: screenWidth * aspectRatio)
    }

    /// Wraps any SwiftUI `View` into a `UIViewController`.
    ///
    /// ## Use Cases:
    /// - Embedding SwiftUI views into UIKit projects
    /// - Pushing SwiftUI screens using a `UINavigationController`
    /// - Presenting SwiftUI views modally from UIKit
    ///
    /// ## Example:
    /// ```swift
    /// let view = MySwiftUIView()
    /// let viewController = view.asViewController()
    /// navigationController?.pushViewController(viewController, animated: true)
    /// ```
    ///
    /// - Returns: A `UIViewController` whose root view is the SwiftUI `View`
    func asViewController() -> UIViewController {
        UIHostingController(rootView: self)
    }
    
    func asTransparentViewController(
        modalPresentationStyle: UIModalPresentationStyle = .overFullScreen,
        modalTransitionStyle: UIModalTransitionStyle = .crossDissolve
    ) -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.modalPresentationStyle = modalPresentationStyle
        vc.modalTransitionStyle = modalTransitionStyle
        vc.view.backgroundColor = .clear
        return vc
    }
    
    func present(_ viewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let rootVC = window.rootViewController else {
            return
        }

        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        topVC.present(viewController, animated: true, completion: nil)
    }
}
