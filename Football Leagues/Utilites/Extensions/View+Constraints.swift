//
//  View+Constraints.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import UIKit

extension UIView {
    
    @discardableResult
    func leadingAnchor(anchor: NSLayoutXAxisAnchor, distance: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = leadingAnchor.constraint(equalTo: anchor, constant: distance)
        const.isActive = true
        return const
    }
    
    @discardableResult
    func trailingAnchor(anchor: NSLayoutXAxisAnchor, distance: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = trailingAnchor.constraint(equalTo: anchor, constant: distance)
        const.isActive = true
        return const
    }
    
    @discardableResult
    func bottomAnchor(anchor: NSLayoutYAxisAnchor, distance: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = bottomAnchor.constraint(equalTo: anchor, constant: distance)
        const.isActive = true
        return const
    }
    
    @discardableResult
    func topAnchorAnchor(anchor: NSLayoutYAxisAnchor, distance: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = topAnchor.constraint(equalTo: anchor, constant: distance)
        const.isActive = true
        return const
    }
    
    @discardableResult
    func centerX(anchor: NSLayoutXAxisAnchor, distance: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = centerXAnchor.constraint(equalTo: anchor, constant: distance)
        const.isActive = true
        return const
    }
    
    @discardableResult
    func centerY(anchor: NSLayoutYAxisAnchor, distance: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = centerYAnchor.constraint(equalTo: anchor, constant: distance)
        const.isActive = true
        return const
    }
    
    @discardableResult
    func widthSize(size: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = widthAnchor.constraint(equalToConstant: size)
        const.isActive = true
        return const
    }
    
    func viewFillConstrains(superView: UIView, distance: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor(anchor: superView.safeAreaLayoutGuide.leadingAnchor, distance: distance)
        trailingAnchor(anchor: superView.safeAreaLayoutGuide.trailingAnchor, distance: -distance)
        topAnchorAnchor(anchor: superView.safeAreaLayoutGuide.topAnchor, distance: distance)
        bottomAnchor(anchor: superView.safeAreaLayoutGuide.bottomAnchor, distance: -distance)
    }
    
    @discardableResult
    func heightSize(size: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let const = heightAnchor.constraint(equalToConstant: size)
        const.isActive = true
        return const
    }
}
