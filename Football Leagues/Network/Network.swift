//
//  Network.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

protocol NetworkProtocol {
    func request <T: Codable>(url: BaseURLRequest) async throws -> AppResponse<T> 
}

class Network {
    // MARK: - Properties
    private let responseError: ResponseErrorProtocol
    private let parser: JsonParserProtocol
    private var session: URLSession
    static let shared = Network()
    init(session: URLSession = URLSession(configuration: .default),
                 responseError: ResponseErrorProtocol = NetworkResponseError(),
                 parser: JsonParserProtocol = JsonParser()) {
        
        self.session = session
        self.responseError = responseError
        self.parser = parser
    }
}

extension Network: NetworkProtocol {
    func request <T: Codable>(url: BaseURLRequest) async throws -> AppResponse<T> {
        let request = url.urlRequest()
        do {
            let (data, _) = try await session.data(for: request)
            let result: AppResponse<T> = self.parser.parse(data: data)
            return result
        } catch {
            let responseError = self.responseError.filter(error: error)
            return .error(responseError)
        }
    }
}
