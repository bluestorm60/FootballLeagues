//
//  NetworkTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

class NetworkTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: Network!
    private var session: URLSession!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        sut = Network(session: session)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        session = nil
        MockURLProtocol.responseError = nil
    }
    
    // MARK: - Request
    func test_request_success_returnLeagues() async {
        MockURLProtocol.responseError = nil
        MockURLProtocol.simulateSuccessResponseWithValidData()
        let request = FootballLeaguesURLRequest.leagues
        
        do{
            let result: AppResponse<LeaguesResponseModel> = try await sut.request(url: request)
            switch result {
            case .success(let model):
                // Check if the model is correctly parsed
                XCTAssertNotNil(model)
            case .error:
                XCTFail("Expected success but got an error.")
            }
        }catch{
            XCTFail("An error occurred: \(error.localizedDescription)")
        }
    }
    
    func test_Request_jsonCanNotDecode_fail() async {
        // Given
        MockURLProtocol.simulateSuccessResponseWithJsonCanNotDecode()
        // When
        let urlRequest = FootballLeaguesURLRequest.leagues
        
        do {
            let result: AppResponse<LeaguesResponseModel> = try await sut.request(url: urlRequest)
            switch result {
            case .success:
                XCTFail("Expected an error but got success.")
            case .error(let networkError):
                XCTAssertEqual(networkError, NetworkError.canNotDecode, "Can not decode json model")
            }
        } catch {
            XCTFail("An error occurred: \(error.localizedDescription)")
        }
    }
    
    func test_request_endPointNotFound_fail() async {
        // Given
        MockURLProtocol.simulateFailResponseEndPointNotFound()
        // When
        let urlRequest = FootballLeaguesURLRequest.leagues

        do {
            let result: AppResponse<LeaguesResponseModel> = try await sut.request(url: urlRequest)
            switch result {
            case .success:
                XCTFail("Error")
            case .error(let networkError):
                XCTAssertNotNil(networkError.description, "Error in url not found")
            }
        } catch {
            XCTAssertNotNil(error.localizedDescription, "Error in url not found")
        }
    }
    
    func test_request_noInternetConnection_fail() async {
        // Given
        MockURLProtocol.responseError = NSError(domain: "", code: -1009, userInfo: nil)
        
        // When
        let urlRequest = FootballLeaguesURLRequest.leagues
        do {
            let result: AppResponse<LeaguesResponseModel> = try await sut.request(url: urlRequest)
            switch result {
            case .success:
                XCTFail("Error")
            case .error(let error):
                XCTAssertEqual(error, NetworkError.noInternet, "There is error for offline connection")
            }
        } catch {
            XCTAssertEqual(error.localizedDescription, NetworkError.noInternet.description)
        }
    }
}
