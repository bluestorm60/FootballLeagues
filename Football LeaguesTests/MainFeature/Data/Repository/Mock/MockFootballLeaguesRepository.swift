//
//  MockFootballLeaguesRepository.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

class MockFootballLeaguesRepository: FootballLeaguesRepository{
    var fetchCompetitionsResult: Result<LeaguesResponseModel, Error>?
    var fetchTeamsResult: Result<TeamsResponseModel, Error>?
    var fetchMatchesResult: Result<CompetitionMatchResponseModel, Error>?
    var teamMatchesResult: Result<TeamMatchesResponseModel, Error>?
    
    func fetchCompetitions() async throws -> AppResponse<LeaguesResponseModel> {
           if let result = fetchCompetitionsResult {
               switch result {
               case .success(let model):
                   return .success(model)
               case .failure:
                   return .error(NetworkError.noInternet)
               }
           }
           return .error(NetworkError.noInternet)
       }
       
       func fetchTeams(competionCode: String) async throws -> AppResponse<TeamsResponseModel> {
           if let result = fetchTeamsResult {
               switch result {
               case .success(let model):
                   return .success(model)
               case .failure:
                   return .error(NetworkError.noInternet)
               }
           }
           return .error(NetworkError.noInternet)
       }
       
       func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchResponseModel> {
           if let result = fetchMatchesResult {
               switch result {
               case .success(let model):
                   return .success(model)
               case .failure:
                   return .error(NetworkError.noInternet)
               }
           }
           return .error(NetworkError.noInternet)
       }
       
       func teamMatches(teamId: Int) async throws -> AppResponse<TeamMatchesResponseModel> {
           if let result = teamMatchesResult {
               switch result {
               case .success(let model):
                   return .success(model)
               case .failure:
                   return .error(NetworkError.noInternet)
               }
           }
           return .error(NetworkError.noInternet)
       }
}
