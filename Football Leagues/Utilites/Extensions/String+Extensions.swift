//
//  String+Extensions.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation

extension String {
    func reformatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: date)
        } else {
            return self
        }
    }
}
