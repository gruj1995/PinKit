//
//  File.swift
//  
//
//  Created by 李品毅 on 2023/7/28.
//

import Foundation

public extension TimeInterval {
    func toString(dateFormat : String? = "yyyyMMddHHmmss") -> String{
        let date = Date(timeIntervalSince1970: self)
        return date.toString(dateFormat: dateFormat)
    }

    func toDate() -> Date{
        return Date(timeIntervalSince1970: self)
    }
}
