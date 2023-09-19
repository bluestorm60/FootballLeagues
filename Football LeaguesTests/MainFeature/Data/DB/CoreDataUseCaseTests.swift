//
//  CoreDataUseCaseTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

final class CoreDataUseCaseTests: XCTestCase {
    
    var sut: MockCoreDataUseCase!
    
    override func setUpWithError() throws {
        sut = MockCoreDataUseCase()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testRetrieveCompetitions_Success() {
        let competitionsToRetrieve: [CoreDataUseCase.CompetitionModel] = MockGenerator.generateCompetitions(count: 5)
        sut.savedCompetitions = competitionsToRetrieve
        
        let expectation = self.expectation(description: "Retrieve Competitions")
        Task {
            do {
                let response = try await sut.retrieveCompetitions()
                switch response {
                case .success(let retrievedCompetitions):
                    XCTAssertEqual(retrievedCompetitions, competitionsToRetrieve, "Data retrieved")
                case .error:
                    XCTFail("Should return success")
                }
                expectation.fulfill()
            } catch {
                XCTFail("Error thrown: \(error)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRetrieveCompetitions_Failure() {
        sut.savedCompetitions = nil
        
        let expectation = self.expectation(description: "Retrieve Competitions")
        Task {
            do {
                let response = try await sut.retrieveCompetitions()
                switch response {
                case .success:
                    XCTFail("Should fail")
                case .error(let error):
                    XCTAssertEqual(error, NetworkError.canNotDecode)
                }
                expectation.fulfill()
            } catch {
                XCTFail("Error thrown: \(error)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    
    func testDeleteCompetitions_Success() {
        let expectation = self.expectation(description: "Delete Competitions")
        
        sut.deleteCompetitions { error in
            XCTAssertNil(error)
            XCTAssertNil(self.sut.savedCompetitions)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSaveTeams_Success() {
        let teamsToSave: [CoreDataUseCase.CompetitionTeams] = MockGenerator.generateCompetitionTeams(count: 20)
        let competitionToAssociateWith: CoreDataUseCase.CompetitionModel = MockGenerator.generateCompetitions(count: 1).first!
        
        let expectation = self.expectation(description: "Save Teams")
        
        sut.saveTeams(teamsToSave, competition: competitionToAssociateWith) { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.sut.savedTeams, teamsToSave)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRetrieveTeamsForCompetition_Success(){
        let teamsToRetrieve: [TeamsUIModel.TeamUIModel] = MockGenerator.generateCompetitionTeams(count: 10)
        sut.teamsToRetrieve = teamsToRetrieve
        sut.retrievedTeamsForCompetitionCode = "code1"
        
        let expectation = self.expectation(description: "Retrieve Competitions")
        Task {
            do {
                let response = try await sut.retrieveTeams(for: "code1")
                switch response {
                case .success(let retrievedTeams):
                    XCTAssertEqual(retrievedTeams, teamsToRetrieve, "Data retrieved")
                case .failure:
                    XCTFail("Should return success")
                }
                expectation.fulfill()
            } catch {
                XCTFail("Error thrown: \(error)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRetrieveTeamsForCompetition_Failure(){
        sut.teamsToRetrieve = nil
        sut.retrievedTeamsForCompetitionCode = "code1"
        
        let expectation = self.expectation(description: "Retrieve Competitions")
        Task {
            do {
                let response = try await sut.retrieveTeams(for: "code1")
                switch response {
                case .success:
                    XCTFail("Should return Fail")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, CoreDataError.objectNotFound.localizedDescription, "Data retrieved")
                }
                expectation.fulfill()
            } catch {
                XCTFail("Error thrown: \(error)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
