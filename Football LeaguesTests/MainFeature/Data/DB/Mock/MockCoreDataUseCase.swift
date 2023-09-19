//
//  MockCoreDataUseCase.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

class MockCoreDataUseCase: CoreDataUseCase {
    var savedCompetitions: [CompetitionModel]?
    var savedTeams: [CompetitionTeams]?
    var deletedCompetitionCode: String?
    var retrievedTeamsForCompetitionCode: String?
    var teamsToRetrieve: [TeamsUIModel.TeamUIModel]?
    
    func saveCompetitions(_ competitions: [CompetitionModel], completion: @escaping (Error?) -> Void) {
        savedCompetitions = competitions
        completion(nil) // Simulate success
    }
    
    func retrieveCompetitions() async throws -> AppResponse<[CompetitionModel]?> {
        if let savedCompetitions = savedCompetitions {
            return .success(savedCompetitions)
        } else {
            return .error(NetworkError.canNotDecode)
        }
    }
    
    func deleteCompetitions(completion: @escaping (Error?) -> Void) {
        savedCompetitions = nil
        completion(nil) // Simulate success
    }
    
    func saveTeams(_ teams: [CompetitionTeams], competition: CompetitionModel, completion: @escaping (CoreDataError?) -> Void) {
        savedTeams = teams
        completion(nil) // Simulate success
    }
    
    func retrieveTeams(for competitionCode: String) async throws -> Result<[TeamsUIModel.TeamUIModel]?, CoreDataError> {
        if let retrievedTeams = teamsToRetrieve, competitionCode == retrievedTeamsForCompetitionCode {
            return .success(retrievedTeams)
        } else {
            return .failure(CoreDataError.objectNotFound)
        }
    }
    
    func deleteTeams(for competitionCode: String, completion: @escaping (CoreDataError?) -> Void) {
        deletedCompetitionCode = competitionCode
        completion(nil) // Simulate success
    }
}
