//
//  File.swift
//  
//
//  Created by 李品毅 on 2023/7/28.
//

import Foundation

public extension Date {
    func toString(dateFormat : String? = "yyyy/MM/dd", locale: Locale = .autoupdatingCurrent) -> String {
        let formatter = DateUtility.dateFormatter
        formatter.dateFormat = dateFormat
        formatter.locale = locale // Locale(identifier: "zh_Hant_TW")
        return formatter.string(from: self)
    }
}
