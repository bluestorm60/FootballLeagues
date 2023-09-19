//
//  CoreDataUseCaseImplTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

final class CoreDataUseCaseImplTests: XCTestCase {
    var sut: CoreDataUseCaseImpl!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
        sut = CoreDataUseCaseImpl(manager: mockCoreDataManager)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockCoreDataManager = nil
        try super.tearDownWithError()
    }
    
    func testSaveCompetitions_Success() {
        let competitions = MockGenerator.generateCompetitions(count: 10)

        let expectation = XCTestExpectation(description: "Save Competitions")
        sut.saveCompetitions(competitions) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func testSaveCompetitions_Failure() {
       let competitions = MockGenerator.generateCompetitions(count: 10)
        mockCoreDataManager.shouldFail = true
       // Act
       let expectation = XCTestExpectation(description: "Save Competitions Failure")
       sut.saveCompetitions(competitions) { error in
           XCTAssertNotNil(error)
           expectation.fulfill()
       }

       wait(for: [expectation], timeout: 1.0)
    }
    
}
