//
//  MockLeaguesUseCase.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

class MockLeaguesUseCase: LeaguesUseCase {
    @Published private(set) var loading: LoadingState = .none
    var loadingPublisher: Published<Football_Leagues.LoadingState>.Publisher {$loading}
    
    var fetchCompetitionsCallCount = 0
    var fetchTeamsCallCount = 0
    var fetchMatchesCallCount = 0
    
    var fetchCompetitionsResult: AppResponse<LeaguesUIModel> = .error(.canNotDecode)
    var fetchTeamsResult: AppResponse<TeamsUIModel> = .error(.canNotDecode)
    var fetchMatchesResult: AppResponse<CompetitionMatchUIModel> = .error(.canNotDecode)
    
    func fetchCompetitions() async throws -> AppResponse<LeaguesUIModel> {
        fetchCompetitionsCallCount += 1
        return fetchCompetitionsResult
    }
    
    func fetchTeams(competition: LeaguesUIModel.CompetitionUIModel) async throws -> AppResponse<TeamsUIModel> {
        fetchTeamsCallCount += 1
        return fetchTeamsResult
    }
    
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchUIModel> {
        fetchMatchesCallCount += 1
        return fetchMatchesResult
    }
}
