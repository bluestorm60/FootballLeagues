//
//  AppResponse.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation


enum AppResponse <T> {
    case success(T)
    case error(NetworkError)
}

enum NetworkError: Equatable, LocalizedError {
    case canNotDecode
    case noInternet
    case error(String)
    
    var description: String {
        switch self {
        case .canNotDecode:
            return "can't Decode"
        case .noInternet:
            return "No internet connection available please check your internet"
        case let .error(custom):
            return custom
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.description == rhs.description
    }
}
