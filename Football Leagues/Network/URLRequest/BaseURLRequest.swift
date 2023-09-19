//
//  BaseURLRequest.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

protocol BaseURLRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var baseUrl: String { get }
    var headers: [String:String]? { get }
    func urlRequest() -> URLRequest
}

extension BaseURLRequest {
    var baseUrl: String {
        return DomainURL.production.path
    }
    
    func urlRequest() -> URLRequest {
        let baseURL = URL(string: baseUrl)!
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}
