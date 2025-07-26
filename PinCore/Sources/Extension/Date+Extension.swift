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

    /// 前一天午夜12:00
    var dayBefore: Date { Calendar.current.date(byAdding: .day, value: -1, to: midnight)! }

    /// 後一天午夜12:00
    var dayAfter: Date { Calendar.current.date(byAdding: .day, value: 1, to: midnight)! }

    var midnight: Date { Calendar.current.startOfDay(for: self) }

    var day: Int { Calendar.current.component(.day, from: self) }

    var month: Int { Calendar.current.component(.month, from: self) }

    var year: Int { Calendar.current.component(.year, from: self) }

    func toString(dateFormat: String? = "yyyy/MM/dd",
                  locale: Locale = .autoupdatingCurrent,
                  timeZone: TimeZone = .autoupdatingCurrent) -> String {
        let formatter = DateUtility.dateFormatter
        formatter.dateFormat = dateFormat
        formatter.locale = locale
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}

public extension Date {
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek: Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast: Bool { self < Date() }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
}
