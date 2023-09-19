//
//  PresentableAlert.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import UIKit

protocol PresentableAlert {
    func showAlert(with message: String)
    func showAlert(with message: String,  completion: @escaping ((UIAlertAction) -> Void))
}

extension PresentableAlert where Self: UIViewController {
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with message: String,  completion: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default,handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
