//
//  LeaguesDIContainer.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import Foundation
import UIKit

final class LeaguesDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: NetworkProtocol
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var storageManager = CoreDataManager.shared

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeLeagueCoreDataUseCase() -> CoreDataUseCase{
        return CoreDataUseCaseImpl(manager: storageManager)
    }
    
    func makeLeaguesUseCase() -> LeaguesUseCase {
        return LeaguesUseCaseImpl(repository: makeLeaguesRepository(), coreDataRepository: makeLeagueCoreDataUseCase())
    }
    
    func makeTeamMatchesUseCase() -> TeamsMatchsUseCase{
        return TeamsMatchsUseCaseImpl(repository: makeLeaguesRepository())
    }
    
    // MARK: - Repositories
    func makeLeaguesRepository() -> FootballLeaguesRepository {
        return FootballLeaguesRepositoryImpl(network: dependencies.apiDataTransferService)
    }
    
    // MARK: - Leagues
    func makeLeaguesListViewController(actions: LeaguesViewModelActions) -> LeaguesViewController{
        return LeaguesViewController(viewModel: makeLeaguesListViewModel(actions: actions))
    }
    
    func makeLeaguesListViewModel(actions: LeaguesViewModelActions) -> LeaguesViewModel{
        return LeaguesViewModel(useCase: makeLeaguesUseCase(), actions: actions)
    }
    
    // MARK: - Teams List
    func makeTeamsViewController(_ item: LeaguesUIModel.CompetitionUIModel, actions: TeamsViewModelActions) -> UIViewController {
        return TeamsViewController(viewModel: makeTeamsViewModel(makeLeaguesUseCase(), item, actions: actions))
    }
    
    func makeTeamsViewModel(_ useCase: LeaguesUseCase,_ item: LeaguesUIModel.CompetitionUIModel, actions: TeamsViewModelActions) -> TeamsViewModel{
        return TeamsViewModel(useCase: useCase, item: item, actions: actions)
    }
    
    //MARK: - Games List Per Team
    func makeTeamGamesViewController(_ item: TeamsUIModel.TeamUIModel) -> UIViewController {
        return TeamDetailsViewController(viewModel: makeTeamGamesViewModel(item))
    }
    
    func makeTeamGamesViewModel(_ item: TeamsUIModel.TeamUIModel) -> TeamDetailsViewModel{
        return TeamDetailsViewModel(useCase: makeTeamMatchesUseCase(), item: item)
    }
    
    // MARK: - Flow Coordinators
    func makeLeaguesFlowCoordinator(navigationController: UINavigationController) -> Coordinator {
        return MainCoordinator(navigationController: navigationController, dependencies: self)
    }
}


extension LeaguesDIContainer: LeaguesFlowCoordinatorDependencies {}
