//
//  TeamsMatchsUseCase.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation

protocol TeamsMatchsUseCase: LoadingUseCase{
    func fetchMatches(teamId: Int) async throws -> Result<[TeamMatchesUIModel.Match]?,NetworkError>
}

final class TeamsMatchsUseCaseImpl{
    @Published private var loading: LoadingState = .none
    var loadingPublisher: Published<LoadingState>.Publisher {$loading}

    private let repository: FootballLeaguesRepository

    init(repository: FootballLeaguesRepository) {
        self.repository = repository
    }
}

extension TeamsMatchsUseCaseImpl: TeamsMatchsUseCase{
    func fetchMatches(teamId: Int) async throws -> Result<[TeamMatchesUIModel.Match]?, NetworkError> {
        loading = .loading
        let response: AppResponse<TeamMatchesResponseModel> = try await repository.teamMatches(teamId: teamId)
        switch response {
        case .success(let response):
            loading = .dismiss
            return .success(response.matches.map({.init(from: $0)}))
        case .error(let networkError):
            loading = .dismiss
            return .failure(networkError)
        }
    }
}
