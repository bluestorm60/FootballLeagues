//
//  MockTeamsMatchsUseCase.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import Foundation
@testable import Football_Leagues

class MockTeamsMatchsUseCase: TeamsMatchsUseCase {
    @Published private(set) var loading: LoadingState = .none
    var loadingPublisher: Published<Football_Leagues.LoadingState>.Publisher {$loading}
    var fetchMatchesResult: Result<[TeamMatchesUIModel.Match]?, NetworkError> = .failure(.canNotDecode)

    func fetchMatches(teamId: Int) async throws -> Result<[TeamMatchesUIModel.Match]?, NetworkError> {
        return fetchMatchesResult
    }
}
