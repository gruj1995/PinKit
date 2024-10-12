//
//  File.swift
//  
//
//  Created by 李品毅 on 2023/7/28.
//

import Foundation

public extension Date {
    static var currentTimestamp: Int {
        Int(Date().timeIntervalSince1970)
    }

    var wholeDayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }

    var midnight: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// 前一天午夜12:00
    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: midnight) ?? self
    }

    /// 後一天午夜12:00
    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: midnight) ?? self
    }

    /// 日末(晚上11:59:59)
    var dayEnd: Date {
        var date = dayAfter
        date.addTimeInterval(-1)
        return date
    }

    var day: Int {
        Calendar.current.component(.day,  from: self)
    }

    var month: Int {
        Calendar.current.component(.month,  from: self)
    }

    var year: Int {
        Calendar.current.component(.year,  from: self)
    }

    func toString(dateFormat : String? = "yyyy/MM/dd", locale: Locale = .autoupdatingCurrent) -> String {
        let formatter = DateUtility.dateFormatter
        formatter.dateFormat = dateFormat
        formatter.locale = locale // Locale(identifier: "zh_Hant_TW")
        return formatter.string(from: self)
    }

    func startOfMonth() -> Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: midnight)
        ) ?? self
    }

    func endOfMonth() -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth()) ?? self
    }
}
