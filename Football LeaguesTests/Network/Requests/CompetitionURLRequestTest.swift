//
//  CompetitionURLRequestTest.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

final class CompetitionURLRequestTest: XCTestCase {
    
    func test_leagues_request_checkParameters() {
        // When
        let leagues = FootballLeaguesURLRequest.leagues
        let path = leagues.path
        let method = leagues.method
        let headers = leagues.headers
        // Then
        XCTAssertEqual(path, "competitions")
        XCTAssertEqual(method, .get, "HTTP method must be GET")
        XCTAssertEqual(headers, ["X-Auth-Token": "e29c2cf472b243f28e0f83afece75404"])
    }
    
    func test_teams_request_checkParameters() {
        // When
        let leagues = FootballLeaguesURLRequest.teams(competionCode: "RSA")
        let path = leagues.path
        let method = leagues.method
        let headers = leagues.headers
        // Then
        XCTAssertEqual(path, "competitions/RSA/teams")
        XCTAssertEqual(method, .get, "HTTP method must be GET")
        XCTAssertEqual(headers, ["X-Auth-Token": "e29c2cf472b243f28e0f83afece75404"])
    }

    func test_matches_request_checkParameters() {
        // When
        let leagues = FootballLeaguesURLRequest.matches(competionCode: "RSA")
        let path = leagues.path
        let method = leagues.method
        let headers = leagues.headers
        // Then
        XCTAssertEqual(path, "competitions/RSA/matches")
        XCTAssertEqual(method, .get, "HTTP method must be GET")
        XCTAssertEqual(headers, ["X-Auth-Token": "e29c2cf472b243f28e0f83afece75404"])
    }

    func test_teamMatches_request_checkParameters() {
        // When
        let leagues = FootballLeaguesURLRequest.teamMatchs(teamId: 500)
        let path = leagues.path
        let method = leagues.method
        let headers = leagues.headers
        // Then
        XCTAssertEqual(path, "teams/500/matches")
        XCTAssertEqual(method, .get, "HTTP method must be GET")
        XCTAssertEqual(headers, ["X-Auth-Token": "e29c2cf472b243f28e0f83afece75404"])
    }
}
