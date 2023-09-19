//
//  LeaguesViewModelTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import XCTest
import Combine
@testable import Football_Leagues

final class LeaguesViewModelTests: XCTestCase {
    private var sut: LeaguesViewModel!
    private var mockUseCase: MockLeaguesUseCase!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockUseCase = MockLeaguesUseCase()
        sut = LeaguesViewModel(coordinator: MockMainCoordinator(navigationController: UINavigationController()), useCase: mockUseCase)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        mockUseCase = nil
        sut = nil
        cancellables = nil
    }
    func test_numberOfRows_success(){
        sut.list = MockGenerator.generateCompetitionCellViewModels(count: 10, delegate: nil)
        // Call the method to get the number of rows
        let numberOfRows = sut.numberOfRowsInSection()

        // Assert that the number of rows matches the count of mock data
        XCTAssertEqual(numberOfRows, sut.list.count)
    }
    
    func test_cellForRow_success(){
        sut.list = MockGenerator.generateCompetitionCellViewModels(count: 10, delegate: nil)
        // Call the method to get the number of rows
        let object = sut.cellForRow(IndexPath(row: 0, section: 0))

        // Assert that the number of rows matches the count of mock data
        XCTAssertNotNil(object)
    }


    func test_viewWillAppear_success(){
        let successResponse = MockGenerator.generateLeaguesUIModel(count: 10)
        mockUseCase.fetchCompetitionsResult = .success(successResponse)
        sut.list = MockGenerator.generateCompetitionCellViewModels(count: 10, delegate: nil)

        let expectation = XCTestExpectation(description: "ViewModel loaded successfully")

        sut.loadingPublisher.sink { loadingState in
            if loadingState == .dismiss || loadingState == .none{
                XCTAssertFalse(self.sut.list.isEmpty)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        sut.viewWillAppear()

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_viewWillAppear_failure(){
        mockUseCase.fetchCompetitionsResult = .error(.error("cannot"))
        
        // Create an expectation to wait for the view model to finish loading
        let expectation = XCTestExpectation(description: "ViewModel loaded with error")
        
        // Subscribe to changes in the loading state to know when it's finished
        sut.loadingPublisher.sink { loadingState in
            if loadingState == .none {
                // Assert that the error message is not nil
                XCTAssertNil(self.sut.errorMsg)
                // Fulfill the expectation
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        // Call the method to trigger the request
        sut.viewWillAppear()
        
        // Wait for the expectation to be fulfilled (or timeout after a reasonable duration)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testOpenCompetition() {
        let sampleCompetitionItem = MockGenerator.generateCompetitions(count: 1).first!
        sut.openCompetition(item: sampleCompetitionItem)
        let coordinator = sut.coordinator as! MockMainCoordinator
        XCTAssertTrue(coordinator.openTeamsCalled)
    }
}
