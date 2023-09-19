//
//  FootballLeaguesRepository.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

protocol FootballLeaguesRepository {
    func fetchCompetitions() async throws -> AppResponse<LeaguesResponseModel>
    func fetchTeams(competionCode: String) async throws -> AppResponse<TeamsResponseModel>
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchResponseModel>
    func teamMatches(teamId: Int) async throws -> AppResponse<TeamMatchesResponseModel>
}

final class FootballLeaguesRepositoryImpl: FootballLeaguesRepository {
    
    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func fetchCompetitions() async throws -> AppResponse<LeaguesResponseModel> {
        return try await network.request(url: FootballLeaguesURLRequest.leagues)
    }
    
    func fetchTeams(competionCode: String) async throws -> AppResponse<TeamsResponseModel> {
        return try await network.request(url: FootballLeaguesURLRequest.teams(competionCode: competionCode))
    }
    
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchResponseModel> {
        return try await network.request(url: FootballLeaguesURLRequest.matches(competionCode: competionCode))
    }
    
    func teamMatches(teamId: Int) async throws -> AppResponse<TeamMatchesResponseModel> {
        return try await network.request(url: FootballLeaguesURLRequest.teamMatchs(teamId: teamId))
    }
}


