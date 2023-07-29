//
//  ArrayExtension.swift
//  
//
//  Created by 李品毅 on 2023/7/26.
//

import Foundation

extension Array where Element: Hashable {
    /// 移除重複值
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    /// 移除重複值(修改自身)
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
