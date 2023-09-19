//
//  CoreDataUseCase.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 16/09/2023.
//

import CoreData
enum CoreDataError: Error {
    case objectNotFound
    case objectNotFoundWith(Error)
    case deleteTeamsFailedWith(Error)
    case deleteTeamsFailed
    case competitionNotFound
    case competitionNotFoundWith(Error)
    case fail(Error)
    case cannotSave
    
}
protocol CoreDataUseCase {
    typealias CompetitionModel = LeaguesUIModel.CompetitionUIModel
    typealias CompetitionTeams = TeamsUIModel.TeamUIModel
    
    func saveCompetitions(_ competitions: [CompetitionModel], completion: @escaping (Error?) -> Void)
    func retrieveCompetitions() async throws -> AppResponse<[CompetitionModel]?>
    func deleteCompetitions(completion: @escaping (Error?) -> Void)
    func saveTeams(_ teams: [CompetitionTeams], competition: CompetitionModel, completion: @escaping (CoreDataError?) -> Void)
    func retrieveTeams(for competitionCode: String) async throws -> Result<[TeamsUIModel.TeamUIModel]?,CoreDataError>
    func deleteTeams(for competitionCode: String, completion: @escaping (CoreDataError?) -> Void)
}


final class CoreDataUseCaseImpl: CoreDataUseCase {
    
    private let manager: CoreDataManagerProtocol
    
    init(manager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.manager = manager
    }
    
    // MARK: - Competition Handling
    func saveCompetitions(_ competitions: [LeaguesUIModel.CompetitionUIModel], completion: @escaping (Error?) -> Void) {
        manager.viewContextBackground.performAndWait {
            do {
                try self.deleteAllCompetitions(context: manager.viewContextBackground)
                try self.saveCompetitionsToContext(competitions, in: manager.viewContextBackground)
                manager.saveContext(errorCompletion: completion)
            } catch {
                completion(error)
            }
        }
    }
    
    func retrieveCompetitions() async throws -> AppResponse<[LeaguesUIModel.CompetitionUIModel]?> {
        return try await withCheckedThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Competition> = Competition.fetchRequest()
            do {
                let competitions = try manager.viewContextBackground.fetch(fetchRequest)
                let competitionsUIModels = competitions.map { self.mapCompetitionToUIModel($0) }
                continuation.resume(returning: competitionsUIModels.isEmpty ? .error(.canNotDecode) : .success(competitionsUIModels))
            } catch {
                continuation.resume(returning: .error(.error(error.localizedDescription)))
                
            }
        }
    }
    
    func deleteCompetitions(completion: @escaping (Error?) -> Void) {
        manager.persistentContainer.performBackgroundTask { context in
            do {
                try self.deleteAllCompetitions(context: context)
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func deleteAllCompetitions(context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<Competition> = Competition.fetchRequest()
        let competitions = try context.fetch(fetchRequest)
        competitions.forEach { context.delete($0) }
    }
    
    private func saveCompetitionsToContext(_ competitions: [LeaguesUIModel.CompetitionUIModel], in context: NSManagedObjectContext) throws {
        for competition in competitions {
            let managedCompetition = Competition(context: context)
            managedCompetition.configure(with: competition)
        }
    }
    
    private func mapCompetitionToUIModel(_ competition: Competition) -> LeaguesUIModel.CompetitionUIModel {
        return LeaguesUIModel.CompetitionUIModel(
            id: Int(competition.id),
            name: competition.name ?? "",
            areaName: competition.areaName ?? "",
            code: competition.code ?? "",
            type: competition.type ?? "",
            emblem: competition.emblem ?? "",
            numberOfmatches: competition.numberOfmatches ?? "",
            numberOfTeams: competition.numberOfTeams ?? "",
            numberOfSeasons: competition.numberOfSeasons ?? ""
        )
    }
    
    
    private func mapTeamToUIModel(_ team: Team) -> TeamsUIModel.TeamUIModel {
        return TeamsUIModel.TeamUIModel(
            id: Int(team.id),
            name: team.name ?? "",
            shortName: team.shortName ?? "",
            crest: team.crest ?? ""
        )
    }
    
    private func findCompetition(with code: String, in context: NSManagedObjectContext) throws -> Competition? {
        let fetchRequest: NSFetchRequest<Competition> = Competition.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        return try context.fetch(fetchRequest).first
    }
    
    private func deleteTeams(for competition: Competition, context: NSManagedObjectContext) throws {
        guard let teams = competition.teams else { return }
        teams.forEach { context.delete($0 ) }
    }
    
    private func saveTeamsToContext(_ teams: [TeamsUIModel.TeamUIModel], for competition: CompetitionModel, in context: NSManagedObjectContext) throws {
        // Fetch or create the related Competition object
        let competitionFetchRequest: NSFetchRequest<Competition> = Competition.fetchRequest()
        competitionFetchRequest.predicate = NSPredicate(format: "code == %@", competition.code)
        
        let competitionManagedObject: Competition
        if let existingCompetition = try context.fetch(competitionFetchRequest).first {
            competitionManagedObject = existingCompetition
        } else {
            competitionManagedObject = Competition(context: context)
            competitionManagedObject.configure(with: competition)
        }
        
        // Create and associate Team objects with the competition
        for team in teams {
            let managedTeam = Team(context: context)
            managedTeam.id = Int64(team.id)
            managedTeam.crest = team.crest
            managedTeam.name = team.name
            managedTeam.shortName = team.shortName
            
            // Associate the team with the competition
            managedTeam.competition = competitionManagedObject
            
            // Insert the team into the context
            context.insert(managedTeam)
        }
    }
    
}


extension CoreDataUseCaseImpl{
    func saveTeams(_ teams: [CompetitionTeams], competition: CompetitionModel, completion: @escaping (CoreDataError?) -> Void) {
        manager.persistentContainer.performBackgroundTask { context in
            do {
                if let competitionEntity = try self.findCompetition(with: competition.code, in: context) {
                    // Delete existing teams for the competition (optional)
                    try self.deleteTeams(for: competitionEntity, context: context)
                    
                    // Save the new teams related to the competition
                    try self.saveTeamsToContext(teams, for: competitionEntity, in: context)
                    
                    // Save the changes
                    try context.save()
                    
                    completion(nil)
                } else {
                    // Competition not found with the provided code
                    completion(.competitionNotFound)
                }
            } catch {
                completion(.objectNotFoundWith(error))
            }
        }
    }
    private func saveTeamsToContext(_ teams: [TeamsUIModel.TeamUIModel], for competition: Competition, in context: NSManagedObjectContext) throws {
        for teamModel in teams {
            let team = Team(context: context)
            team.id = Int64(teamModel.id)
            team.name = teamModel.name
            team.shortName = teamModel.shortName
            team.crest = teamModel.crest
            team.competition = competition
            context.insert(team)
        }
    }
    
    func retrieveTeams(for competitionCode: String) async throws -> Result<[TeamsUIModel.TeamUIModel]?, CoreDataError> {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let competition = try self.findCompetition(with: competitionCode, in: manager.viewContextBackground) else {
                    continuation.resume(returning: .failure(.objectNotFound))
                    return
                }
                
                // Check if the competition has associated teams
                guard let teamSet = competition.teams else {
                    // If there are no teams associated with the competition, return an empty array
                    continuation.resume(returning: .failure(.objectNotFound))
                    return
                }
                
                // Convert the set of Team objects to an array of TeamUIModel
                let teamUIModels = teamSet.map { team in
                    return TeamsUIModel.TeamUIModel(from: team)
                }.sorted(by: {$0.id < $1.id})
                
                // Call the completion handler with the retrieved team UI models
                continuation.resume(returning: teamUIModels.count == 0 ? .failure(.objectNotFound) : .success(teamUIModels))
            } catch {
                // Call the completion handler with the error
                continuation.resume(returning: .failure(.objectNotFoundWith(error)))
            }
        }
    }
    
    func deleteTeams(for competitionCode: String, completion: @escaping (CoreDataError?) -> Void) {
        manager.persistentContainer.performBackgroundTask { context in
            do {
                // Step 1: Find the competition entity based on the competition code
                guard let competitionEntity = try self.findCompetition(with: competitionCode, in: context) else {
                    completion(.competitionNotFound)
                    return
                }
                // Step 2: Delete all associated teams
                try self.deleteTeams(for: competitionEntity, context: context)
                // Step 3: Save the context to persist the changes
                try context.save()
                // Step 4: Call the completion handler with no error to indicate success
                completion(nil)
            } catch {
                // Handle errors and call the completion handler with the appropriate CoreDataError
                completion(.deleteTeamsFailedWith(error))
            }
        }
    }
}
