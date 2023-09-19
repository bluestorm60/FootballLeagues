//
//  TeamsCellViewModelTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import XCTest
@testable import Football_Leagues

final class TeamsCellViewModelTests: XCTestCase {
    var sut: TeamsCellViewModel!
    
    override func setUpWithError() throws {
        sut = TeamsCellViewModel(MockGenerator.generateCompetitionTeams(count: 1).first!, nil)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_getImgeURL(){
        let imgeUrl = sut.getImgeUrl()
        XCTAssertEqual(imgeUrl, "https://crests.football-data.org/1765.svg")
    }
    
    func test_getTeamName(){
        let name = sut.getTeamName()
        XCTAssertEqual(name, "Team 1")
    }
    
}


