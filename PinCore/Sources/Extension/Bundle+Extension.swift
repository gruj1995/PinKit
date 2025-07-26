//
//  Bundle+Extension.swift
//  PinKit
//
//  Created by pinyi Li on 2025/5/16.
//

import Foundation

public extension Bundle {
    /// 優先從 main bundle 尋找資源，找不到時從 module bundle 尋找。
    static func resourcePath(named name: String,
                             ofType type: String,
                             fallback bundle: Bundle) -> String? {
        if let mainPath = Bundle.main.path(forResource: name, ofType: type) {
            return mainPath
        }
        return bundle.path(forResource: name, ofType: type)
    }

    /// 優先從 main bundle 尋找資源 URL，找不到時從 module bundle 尋找。
    static func resourceURL(named name: String,
                            extension ext: String,
                            fallback bundle: Bundle) -> URL? {
        if let mainURL = Bundle.main.url(forResource: name, withExtension: ext) {
            return mainURL
        }
        return bundle.url(forResource: name, withExtension: ext)
    }
}
