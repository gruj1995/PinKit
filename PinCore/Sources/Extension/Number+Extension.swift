//
//  Number+Extension.swift
//  PinKit
//
//  Created by 李品毅 on 2025/7/26.
//

import Foundation

//public extension Double {
//    /// 將一個 Double 值表示的文件大小（以字節為單位）轉換為 MB、GB 等單位
//    func formatFileSize() -> String {
//        let byteCount = self
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useMB, .useGB, .useTB, .usePB]
//        formatter.countStyle = .file
//        return formatter.string(fromByteCount: Int64(byteCount))
//    }
//}

public extension Numeric {
    /// Converts the numeric value (assumed to be a timestamp in seconds) to a `Date`.
    /// - Returns: A `Date` object representing the timestamp.
    func toDate() -> Date {
        let timeInterval = TimeInterval(truncating: self as! NSNumber)
        return Date(timeIntervalSince1970: timeInterval)
    }

    func toDateString(dateFormat: String? = "yyyy/MM/dd") -> String {
        let timeInterval = TimeInterval(truncating: self as! NSNumber)
        return Date(timeIntervalSince1970: timeInterval).toString(dateFormat: dateFormat)
    }
}

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

public extension BinaryInteger {
    /// 安全計算目前 / 總和 的比例（0 ~ 1）
    /// - Parameters:
    ///   - total: 總和值
    /// - Returns: 比例值（型別由呼叫方決定，支援 Float 或 Double）
    func ratio<T: BinaryFloatingPoint>(to total: Self, as _: T.Type = T.self) -> T {
        guard total > 0 else { return 0 }
        return T(self) / T(total)
    }
}

public extension BinaryFloatingPoint {
    /// 四捨五入到最近的整數
    func roundedToNearestInt() -> Int {
        return Int(rounded(.toNearestOrAwayFromZero))
    }

    /// 四捨五入到指定的小數位數
    func rounded(to places: Int) -> Self {
        let multiplier = Self(pow(10.0, Double(places))) // 使用 Self 表示泛型类型
        return (self * multiplier).rounded(.toNearestOrAwayFromZero) / multiplier
    }
}

public extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }

    var floatValue: Float {
        return NSDecimalNumber(decimal: self).floatValue
    }

    var absValue: Decimal { abs(self) }
}
