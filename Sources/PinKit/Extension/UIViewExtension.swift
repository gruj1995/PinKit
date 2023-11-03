//
//  File.swift
//  
//
//  Created by 李品毅 on 2023/11/3.
//

import UIKit

public extension UIView {

    static func emptyView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    /// Find all subviews of the specific type T.
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

// MARK: - Border

public extension UIView {
    private enum RectangularEdges {
        case left
        case right
        case top
        case bottom
    }

    private class BorderView: UIView {} // dummy class to help us differentiate among border views and other views
                                            // to enabling us to remove existing borders and place new ones

    /// vInset: 值越大越往上方
    /// hInset: 值越大越短
    func setBorders(toEdges edges: [UIRectEdge], withColor color: UIColor, hInset: CGFloat = 0, vInset: CGFloat = 0, thickness: CGFloat = 1) {
        // Remove existing edges
        for view in subviews {
            if view is BorderView {
                view.removeFromSuperview()
            }
        }
        // Add new edges
        if edges.contains(.all) {
            addSidedBorder(toEdge: [.left,.right, .top, .bottom], withColor: color, insetH: hInset, insetV: vInset, thickness: thickness)
        }
        if edges.contains(.left) {
            addSidedBorder(toEdge: [.left], withColor: color, insetH: hInset, insetV: vInset, thickness: thickness)
        }
        if edges.contains(.right) {
            addSidedBorder(toEdge: [.right], withColor: color, insetH: hInset, insetV: vInset, thickness: thickness)
        }
        if edges.contains(.top) {
            addSidedBorder(toEdge: [.top], withColor: color, insetH: hInset, insetV: vInset, thickness: thickness)
        }
        if edges.contains(.bottom) {
            addSidedBorder(toEdge: [.bottom], withColor: color, insetH: hInset, insetV: vInset, thickness: thickness)
        }
    }

    private func addSidedBorder(toEdge edges: [RectangularEdges], withColor color: UIColor, insetH: CGFloat, insetV: CGFloat, thickness: CGFloat) {
        for edge in edges {
            let border = BorderView(frame: .zero)
            border.backgroundColor = color
            addSubview(border)
            border.translatesAutoresizingMaskIntoConstraints = false
            switch edge {
            case .left:
                NSLayoutConstraint.activate([
                    border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: insetH),
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: insetV),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insetV),
                    NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: thickness) ])
            case .right:
                NSLayoutConstraint.activate([
                    border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -insetH),
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: insetV),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insetV),
                    NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: thickness) ])
            case .top:
                NSLayoutConstraint.activate([
                    border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: insetH),
                    border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -insetH),
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: insetV),
                    NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: thickness) ])
            case .bottom:
                NSLayoutConstraint.activate([
                    border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: insetH),
                    border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -insetH),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insetV),
                    NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: thickness) ])
            }
        }
    }
}
