//
//  UITableView+Extensions.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import UIKit

extension UITableView
{
    func registerNib<T: UITableViewCell>(_ cellClass: T.Type, bundle: Bundle? = nil , _ identifierNib : String? = nil ){
        let identifier = String(describing: T.self)
        let nibIdentifer = (identifierNib == nil) ? identifier : identifierNib!
        self.register(UINib(nibName: nibIdentifer, bundle: bundle), forCellReuseIdentifier: nibIdentifer)
    }
}
