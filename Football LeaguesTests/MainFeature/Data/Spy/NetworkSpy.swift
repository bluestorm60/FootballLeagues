//
//  NetworkSpy.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

class NetworkSpy: NetworkProtocol {
    var requestCalled = false
    var requestResult: AppResponse<Any> = .success("Mocked Data")

    func request<T>(url: BaseURLRequest) async throws -> AppResponse<T> where T : Decodable, T : Encodable {
        requestCalled = true
        return .error(NetworkError.canNotDecode)
    }
}
