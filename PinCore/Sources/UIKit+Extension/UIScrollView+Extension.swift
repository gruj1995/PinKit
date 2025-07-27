//
//  UIScrollView+Extension.swift
//
//
//  Created by pinyi Li on 2024/8/16.
//

import UIKit

public extension UIScrollView {
    /// 回傳目前可見區域（視窗範圍）
    var visibleRect: CGRect {
        CGRect(origin: contentOffset, size: bounds.size)
    }

    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    @MainActor
    func scrollToBottom(animated: Bool) {
        if contentSize.height < bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
}

public extension UICollectionView {
    func isCellPartiallyVisible(at indexPath: IndexPath) -> Bool {
        guard let cell = cellForItem(at: indexPath) else { return false }
        return visibleRect.intersects(cell.frame)
    }
    
    func isCellPartiallyVisible(visibleRect: CGRect, cellFrame: CGRect) -> Bool {
        return visibleRect.intersects(cellFrame)
    }
}

// MARK: - Identifier

public extension UICollectionReusableView {
    class var identifier: String {
        return String(describing: self)
    }
}

public extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}

public extension UITableViewHeaderFooterView {
    class var identifier: String {
        return String(describing: self)
    }
}

// MARK: - Dequeue Cell

public extension UICollectionView {
    /// Registers a UICollectionViewCell subclass with the collection view using its identifier.
    /// The cell's identifier is assumed to be a static property named `identifier` in the cell class.
    /// - Parameter cellType: The UICollectionViewCell subclass to register.
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: T.identifier)
    }

    /// Dequeues a reusable cell of the specified type.
    /// - Parameters:
    ///   - cellType: The UICollectionViewCell subclass to dequeue.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A reusable cell of the specified type.
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType _: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

public extension UITableView {
    /// Registers a UITableViewCell subclass with the table view using its identifier.
    /// The cell's identifier is assumed to be a static property named `identifier` in the cell class.
    /// - Parameter cellType: The UITableViewCell subclass to register.
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: T.identifier)
    }

    /// Dequeues a reusable cell of the specified type.
    /// - Parameters:
    ///   - cellType: The UITableViewCell subclass to dequeue.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A reusable cell of the specified type.
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType _: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

// MARK: - Dequeue header footer View

public extension UICollectionView {
    func register<T: UICollectionReusableView>(_ viewType: T.Type, ofKind elementKind: String) {
        register(viewType, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.identifier)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T? {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            return nil
        }
        return view
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.identifier)")
        }
        return view
    }
}

public extension UITableView {
    func register<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        register(viewType, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            return nil
        }
        return view
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.identifier)")
        }
        return view
    }
}

// MARK: - NSCollectionLayoutGroup

public extension NSCollectionLayoutGroup {
    static func setHorizontalRepeatingGroup(groupSize: NSCollectionLayoutSize, repeatingSubitem item: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: count)
    }
}
