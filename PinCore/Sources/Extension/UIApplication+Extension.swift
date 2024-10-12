//
//  UIApplication+Extension.swift
//
//
//  Created by 李品毅 on 2023/7/14.
//

import UIKit

public extension UIApplication {
    var keyWindowCompact: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    var rootViewController: UIViewController? {
        keyWindowCompact?.rootViewController
    }

    func getTopViewController(base: UIViewController? = UIApplication.shared.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }

    // 參考: https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/

    func changeRootViewController(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let window = keyWindowCompact else { return }

        // 延遲一秒再轉場
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            window.rootViewController = vc
            // add animation
            UIView.transition(with: window,
                              duration: 0.1,
                              options: [.transitionCrossDissolve],
                              animations: {}) {_ in
                window.rootViewController = vc
                completion?()
            }
        }
    }
}
