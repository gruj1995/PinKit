//
//  PinLogger.swift
//
//
//  Created by 李品毅 on 2023/7/14.
//

import Foundation

public class PinLogger {

    /// 輸出訊息
    public static func log<T>(_ message: T) {
        #if DEBUG
        print(message)
        #endif
    }

    /// 記錄訊息來源的檔案名稱和方法名稱
    public static func log<T>(message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName): \(method)] \(message)")
        #endif
    }
}
