//
//  TestHelpers.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation
import XCTest

extension Bundle {
    public class var testBundle: Bundle {
        return Bundle(for: NetworkTests.self)
    }
}

// MARK: - helpers
func getJSON(bundle: Bundle, for jsonName: String) -> Data {
    guard let path = bundle.path(forResource: jsonName, ofType: "json") else {
        fatalError("Could not retrieve file \(jsonName).json")
    }
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    return data
}
