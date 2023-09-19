//
//  FootballLeaguesRepositoryTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

final class FootballLeaguesRepositoryTests: XCTestCase {
    private var sut: FootballLeaguesRepository!
    private var netWork: NetworkSpy!

    override func setUpWithError() throws {
        netWork = NetworkSpy()
        sut = FootballLeaguesRepositoryImpl(network: netWork)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchCompetitions_isCalled_successfully() async throws {

        // Act
        let _: AppResponse<LeaguesResponseModel> = try await sut.fetchCompetitions()

        // Assert
        XCTAssertTrue(netWork.requestCalled)
    }
    
    func test_fetchTeams_isCalled_successfully() async throws {

        // Act
        let _: AppResponse<TeamsResponseModel> = try await sut.fetchTeams(competionCode: "RSA")

        // Assert
        XCTAssertTrue(netWork.requestCalled)
    }

    func test_fetchMatches_isCalled_successfully() async throws {

        // Act
        let _: AppResponse<CompetitionMatchResponseModel> = try await sut.fetchMatches(competionCode: "RSA")

        // Assert
        XCTAssertTrue(netWork.requestCalled)
    }

    func test_teamMatches_isCalled_successfully() async throws {

        // Act
        let _: AppResponse<TeamMatchesResponseModel> = try await sut.teamMatches(teamId: 50)

        // Assert
        XCTAssertTrue(netWork.requestCalled)
    }

}
