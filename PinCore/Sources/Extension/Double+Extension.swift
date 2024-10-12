//
//  File.swift
//  
//
//  Created by 李品毅 on 2023/11/3.
//

import Foundation

public extension Double {
    /// 將一個 Double 值表示的文件大小（以字節為單位）轉換為 MB、GB 等單位
    func formatFileSize() -> String {
        let byteCount = self
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB, .useTB, .usePB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(byteCount))
    }
}
