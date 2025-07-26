//
//  Utils.swift
//
//
//  Created by pinyi Li on 2024/7/23.
//

import PinCore
import UIKit

public enum Utils {
    /// 顯示 toast
    /// - Parameters:
    ///  - msg: toast message
    ///  - position: 出現位置
    ///  - textAlignment: 文字對齊方式
    public static func toast(_ msg: String,
                             at position: ToastHelper.ToastPosition = .bottom,
                             alignment: NSTextAlignment = .center) {
        ToastHelper.shared.showToast(text: msg, position: position, alignment: alignment)
    }
}
