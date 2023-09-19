//
//  DomainURL.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

enum DomainURL {
    
    case production
    
    var path: String {
        switch self {
        case .production:
            return "https://api.football-data.org/v4/"
        }
    }
}
