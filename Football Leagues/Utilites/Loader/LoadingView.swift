//
//  LoadingView.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import UIKit

class LoadingView: UIView {
    
    static let shared = LoadingView()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .systemBlue
        activityIndicator.color = .systemGray
        return activityIndicator
    }()
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        addSubview(activityIndicator)
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        
        activityIndicator.centerX(anchor: centerXAnchor)
        activityIndicator.centerY(anchor: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}
