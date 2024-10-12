//
//  UITableViewExtension.swift
//  
//
//  Created by 李品毅 on 2023/7/19.
//

import UIKit

public extension UITableView {
    /// 滾動到頂部
    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToIndexPath(indexPath, position: .top, animated: animated)
    }

    /// 滾動到底部
    func scrollToBottom(animated: Bool) {
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: lastSection) - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        scrollToIndexPath(indexPath, position: .bottom, animated: animated)
    }

    /// 滾動到指定位置
    func scrollToIndexPath(_ indexPath: IndexPath, position: UITableView.ScrollPosition, animated: Bool) {
        DispatchQueue.main.async {
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: position, animated: animated)
            }
        }
    }

    private func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
}
