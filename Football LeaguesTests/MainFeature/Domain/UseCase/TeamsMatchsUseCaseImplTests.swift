//
//  TeamsMatchsUseCaseImplTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import XCTest
import Combine
@testable import Football_Leagues

final class TeamsMatchsUseCaseImplTests: XCTestCase {
    private var sut: TeamsMatchsUseCaseImpl!
    private var mockFootballLeaguesRepository: MockFootballLeaguesRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockFootballLeaguesRepository = MockFootballLeaguesRepository()
        sut = TeamsMatchsUseCaseImpl(repository: mockFootballLeaguesRepository)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        mockFootballLeaguesRepository = nil
        sut = nil
        cancellables = nil
    }
    
    func test_fetchMatches_success() async throws {
        let matches = StubsModels.getTeamGamesResponse()
        mockFootballLeaguesRepository.teamMatchesResult = .success(matches!)
      let result = try await sut.fetchMatches(teamId: 1765)
            switch result {
            case .success(let success):
                XCTAssertEqual(success?.count ?? 0, matches!.matches.count)
            case .failure:
                XCTFail("Expected success, but got an error")
            }
    }
    
    func test_fetchMatches_failure() async throws{
        mockFootballLeaguesRepository.teamMatchesResult = .failure(NetworkError.noInternet)
            let result = try await sut.fetchMatches(teamId: 1765)
            switch result {
            case .success:
                XCTFail("Expected an error, but got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.noInternet)
            }
    }
}
