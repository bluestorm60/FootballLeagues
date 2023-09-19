//
//  URLStubs.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation

enum URLStubs {
    static var url: URL { URL(string: "//any.com/")! }
    static var urlRequest: URLRequest { URLRequest(url: url) }
}
