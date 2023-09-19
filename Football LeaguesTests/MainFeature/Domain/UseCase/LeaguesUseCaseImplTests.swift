//
//  LeaguesUseCaseImplTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

final class LeaguesUseCaseImplTests: XCTestCase {
    var sut: LeaguesUseCaseImpl!
    var mockFootballLeaguesRepository: MockFootballLeaguesRepository!
    var mockCoreDataUseCase: MockCoreDataUseCase!
    
    override func setUpWithError() throws {
        mockFootballLeaguesRepository = MockFootballLeaguesRepository()
        mockCoreDataUseCase = MockCoreDataUseCase()
        sut = LeaguesUseCaseImpl(
            repository: mockFootballLeaguesRepository,
            coreDataRepository: mockCoreDataUseCase
        )
        
    }

    override func tearDownWithError() throws {
        sut = nil
        mockFootballLeaguesRepository = nil
        mockCoreDataUseCase = nil
        super.tearDown()
        
    }

    func testFetchCompetitions_LocalDataAvailable_Success() async {
        // Arrange
        // Prepare mock data
        let competitions = MockGenerator.generateCompetitions(count: 10)
        mockCoreDataUseCase.savedCompetitions = competitions

        
        // Call the method being tested
        let result = try? await sut.fetchCompetitions()

        // Assert the result
        guard let result = result else {return}
        switch result {
        case .success(let uiModel):
            XCTAssertEqual(uiModel.count, competitions.count)
            XCTAssertEqual(uiModel.competitions, competitions)
        case .error:
            XCTFail("Expected success, but got an error")
        }
    }
    
    func testFetchCompetitions_LocalDataAvailable_Failure() async {
        mockCoreDataUseCase.savedCompetitions = nil

        // Call the method being tested
        let result = try? await sut.fetchCompetitions()

        // Assert the result
        guard let result = result else {return}
        switch result {
        case .success:
            XCTFail("Expected an error, but got success")
        case .error(let error):
            XCTAssertEqual(error, NetworkError.noInternet)
        }
    }
    
    func testFetchCompetitions_Remotely_Success() async throws {
        // Prepare mock data
        let competitionsResponse = MockGenerator.generateCompetitionsResponse(count: 10)
        mockFootballLeaguesRepository.fetchCompetitionsResult = .success(competitionsResponse)

        // Call the method being tested
        let result = try await sut.fetchCompetitions()

        // Assert the result
        switch result {
        case .success(let uiModel):
            XCTAssertEqual(uiModel.count, competitionsResponse.competitions.count)
        case .error:
            XCTFail("Expected success, but got an error")
        }
    }
    
    func testFetchCompetitions_Remotely_Failure() async throws {
        // Prepare mock data for failure
        mockFootballLeaguesRepository.fetchCompetitionsResult = .failure(NetworkError.noInternet)

        // Call the method being tested
        let result = try await sut.fetchCompetitions()

        // Assert the result
        switch result {
        case .success:
            XCTFail("Expected an error, but got success")
        case .error(let error):
            XCTAssertEqual(error, NetworkError.noInternet)
        }
    }
    
    func testFetchTeams_Locally_Success() async throws {
        // Prepare mock data
        let competition = MockGenerator.generateCompetitions(count: 1).first!
        let teams = MockGenerator.generateCompetitionTeams(count: 10)
        mockCoreDataUseCase.teamsToRetrieve = teams
        mockCoreDataUseCase.retrievedTeamsForCompetitionCode = "Code1"
        // Call the method being tested
        let result = try await sut.fetchTeams(competition: competition)

        // Assert the result
        switch result {
        case .success(let uiModel):
            XCTAssertEqual(uiModel.count, teams.count)
            XCTAssertEqual(uiModel.competition.id, competition.id)
            XCTAssertEqual(uiModel.teams, teams)
        case .error:
            XCTFail("Expected success, but got an error")
        }
    }
    
    func testFetchTeams_Locally_Failure() async throws {
        // Prepare mock data
        let competition = MockGenerator.generateCompetitions(count: 1).first!
        mockCoreDataUseCase.teamsToRetrieve = nil
        mockCoreDataUseCase.retrievedTeamsForCompetitionCode = "Code1"
        // Call the method being tested
        let result = try await sut.fetchTeams(competition: competition)

        // Assert the result
        switch result {
        case .success:
            XCTFail("Expected an error, but got success")
        case .error(let error):
            XCTAssertEqual(error, NetworkError.noInternet)
        }
    }

    func testFetchTeams_Remotely_Success() async throws {
        // Prepare mock data
        let competition = MockGenerator.generateCompetitions(count: 1).first!
        let teamsResponse = MockGenerator.generateTeamsResponseModel(count: 10)
        mockFootballLeaguesRepository.fetchTeamsResult = .success(teamsResponse)

        // Call the method being tested
        let result = try await sut.fetchTeams(competition: competition)

        // Assert the result
        switch result {
        case .success(let uiModel):
            XCTAssertEqual(uiModel.count, teamsResponse.teams.count)
            XCTAssertEqual(uiModel.competition.id, competition.id)
        case .error:
            XCTFail("Expected success, but got an error")
        }
    }

    func testFetchTeamsRemotelyFailure() async throws {
        // Prepare mock data for failure
        let competition = MockGenerator.generateCompetitions(count: 1).first!
        mockFootballLeaguesRepository.fetchTeamsResult = .failure(NetworkError.noInternet)

        // Call the method being tested
        let result = try await sut.fetchTeams(competition: competition)

        // Assert the result
        switch result {
        case .success:
            XCTFail("Expected an error, but got success")
        case .error(let error):
            XCTAssertEqual(error, NetworkError.noInternet)
        }
    }
    
    func testFetchMatches_Success() async throws {
        // Prepare mock data
        let count = 10
        let competitionCode = "code1"
        let matchesResponse = MockGenerator.generateCompetitionMatchResponseModel(count: count)
        mockFootballLeaguesRepository.fetchMatchesResult = .success(matchesResponse)

        // Call the method being tested
        let result = try await sut.fetchMatches(competionCode: competitionCode)

        // Assert the result
        switch result {
        case .success(let uiModel):
            XCTAssertEqual(uiModel.resultSet.count, matchesResponse.resultSet.count)
        case .error:
            XCTFail("Expected success, but got an error")
        }
    }

    func testFetchMatches_Failure() async throws {
        // Prepare mock data for failure
        let competitionCode = "code1"
        mockFootballLeaguesRepository.fetchMatchesResult = .failure(NetworkError.noInternet)

        // Call the method being tested
        let result = try await sut.fetchMatches(competionCode: competitionCode)

        // Assert the result
        switch result {
        case .success:
            XCTFail("Expected an error, but got success")
        case .error(let error):
            XCTAssertEqual(error, NetworkError.noInternet)
        }
    }
    
}
