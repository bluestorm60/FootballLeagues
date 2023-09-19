//
//  File.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

protocol LeaguesUseCase: LoadingUseCase{
    func fetchCompetitions() async throws -> AppResponse<LeaguesUIModel>
    func fetchTeams(competition: LeaguesUIModel.CompetitionUIModel) async throws -> AppResponse<TeamsUIModel>
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchUIModel>
}

final class LeaguesUseCaseImpl{
    @Published private var loading: LoadingState = .none
    var loadingPublisher: Published<LoadingState>.Publisher {$loading}

    private let repository: FootballLeaguesRepository
    private let coreDataRepository: CoreDataUseCase

    init(repository: FootballLeaguesRepository,coreDataRepository: CoreDataUseCase) {
        self.repository = repository
        self.coreDataRepository = coreDataRepository
    }
}

extension LeaguesUseCaseImpl: LeaguesUseCase{
    func fetchCompetitions() async throws -> AppResponse<LeaguesUIModel> {
        //First check for local Data
        let response = try await coreDataRepository.retrieveCompetitions()
        switch response {
        case .success(let competitions):
            //success fetching data locally
            return .success(.init(count: competitions?.count, competitions: competitions))
        case .error(_):
            //fetch data remotely
                return try await fetchCompetitionsWithDependancies()
        }
    }
}

//MARK: - private Remotely Calls
extension LeaguesUseCaseImpl{
    
    private func fetchCompetitionsWithDependancies() async throws -> AppResponse<LeaguesUIModel>{
        loading = .loading
        let response: AppResponse<LeaguesUIModel> = try await fetchCompetitionsRemotely()
        switch response {
        case .success(let response):
            let result = await handleSuccessResponseCompetitions(response)
            coreDataRepository.saveCompetitions(result.competitions) { error in
                print("Save Competition : \(String(describing: error?.localizedDescription))")
            }
            loading = .dismiss
            return .success(result)
        case .error(let networkError):
            loading = .dismiss
            return .error(networkError)
        }
    }
    
    private func handleSuccessResponseCompetitions(_ response: LeaguesUIModel) async -> LeaguesUIModel{
        let teams = try? await getCompetitionTeams(items: response.competitions)
        let matches = try? await getCompetitionMatches(items: teams ?? response.competitions)
        var result = response
        result.competitions = matches ?? response.competitions
        return response
    }

    //Fetch Competitions Remotely
    private func fetchCompetitionsRemotely() async throws -> AppResponse<LeaguesUIModel>{
        let networkResult: AppResponse<LeaguesResponseModel> = try await repository.fetchCompetitions()
        switch networkResult {
        case .success(let leaguesResponse):
            // Convert the network response to UIModel
            let uiModel = LeaguesUIModel(from: leaguesResponse)
            return .success(uiModel)
        case .error(let error):
            // Propagate any network errors
            return .error(error)
        }
    }
}


extension LeaguesUseCaseImpl{
    func fetchTeams(competition: LeaguesUIModel.CompetitionUIModel) async throws -> AppResponse<TeamsUIModel> {
        //First check for local Data
        let response = try await coreDataRepository.retrieveTeams(for: competition.code)
        switch response {
        case .success(let teams):
            let competition = TeamsUIModel.CompetitionUIModel(id: competition.id, name: competition.name, code: competition.code, type: competition.type, emblem: competition.emblem)
            let leagues = TeamsUIModel(count: teams?.count ?? 0, competition: competition, teams: teams ?? [])
            return .success(leagues)
        case .failure(_):
            return try await fetchTeamsRemotely(competition: competition)
        }
    }
    
    //Fetch teams Remotely
    private func fetchTeamsRemotely(competition: LeaguesUIModel.CompetitionUIModel) async throws -> AppResponse<TeamsUIModel> {
        loading = .loading
        let networkResult: AppResponse<TeamsResponseModel> = try await repository.fetchTeams(competionCode: competition.code)
        switch networkResult {
        case .success(let teamsResponse):
            // Convert the network response to UIModel
            let uiModel = TeamsUIModel(from: teamsResponse)
            coreDataRepository.saveTeams(uiModel.teams, competition: competition) { result in
                print("Save Teams : \(String(describing: result?.localizedDescription))")
            }
            loading = .dismiss
            return .success(uiModel)
        case .error(let error):
            loading = .dismiss
            // Propagate any network errors
            return .error(error)
        }
    }
}

extension LeaguesUseCaseImpl{
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchUIModel> {
        let networkResult: AppResponse<CompetitionMatchResponseModel> = try await repository.fetchMatches(competionCode: competionCode)
        switch networkResult {
        case .success(let matchesResponse):
            // Convert the network response to UIModel
            let uiModel = CompetitionMatchUIModel(from: matchesResponse)
            return .success(uiModel)
        case .error(let error):
            // Propagate any network errors
            return .error(error)
        }
    }
}


//MARK: - Call dependencies
#warning("To be refactor")
extension LeaguesUseCaseImpl{
    private func getCompetitionTeams(items: [LeaguesUIModel.CompetitionUIModel]) async throws -> [LeaguesUIModel.CompetitionUIModel]{
        let allReaults = try await withThrowingTaskGroup(of: AppResponse<TeamsUIModel>.self, returning: [LeaguesUIModel.CompetitionUIModel].self, body: { taskGroup in
            let list = items
            for item in list{
                taskGroup.addTask { try await self.fetchTeams(competition: item) }
            }
            var teams = [LeaguesUIModel.CompetitionUIModel]()
            while let team = try await taskGroup.next() {
                switch team {
                case .success(let model):
                    if let result = updateCompetition(list, model.competition.code, model.count) {
                        teams.append(result)
                    }else{
                        throw NetworkError.canNotDecode
                    }
                case .error(let error):
                    throw error
                }
            }
            return teams
        })
        return allReaults
    }
    
    private func getCompetitionMatches(items: [LeaguesUIModel.CompetitionUIModel]) async throws -> [LeaguesUIModel.CompetitionUIModel]{
        let allReaults = try await withThrowingTaskGroup(of: AppResponse<CompetitionMatchUIModel>.self, returning: [LeaguesUIModel.CompetitionUIModel].self, body: { taskGroup in
            let list = items
            for item in list{
                taskGroup.addTask {try await self.fetchMatches(competionCode: item.code)}
            }
            var teams = [LeaguesUIModel.CompetitionUIModel]()
            
            while let team = try await taskGroup.next() {
                switch team {
                case .success(let model):
                    if let result = updateCompetition(list, model.competition.code, model.resultSet.count) {
                        teams.append(result)
                    }else{
                        throw NetworkError.canNotDecode
                    }
                case .error(let error):
                    throw error
                }
            }
            return teams
        })
        return allReaults
    }
    
    private func updateCompetition(_ list: [LeaguesUIModel.CompetitionUIModel],_ currentCode: String, _ count: Int) -> LeaguesUIModel.CompetitionUIModel?{
        if var competition = list.first(where: {$0.code == currentCode}){
            competition.numberOfTeams = "\(count)"
            return competition
        }
        return nil
    }
}
