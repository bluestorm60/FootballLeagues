//
//  Coordinator.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
}


