//
//  MainCoordinator.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit

protocol LeaguesFlowCoordinatorDependencies  {
    func makeLeaguesListViewController(actions: LeaguesViewModelActions) -> LeaguesViewController
    func makeTeamsViewController(_ item: LeaguesUIModel.CompetitionUIModel, actions: TeamsViewModelActions) -> UIViewController
    func makeTeamGamesViewController(_ item: TeamsUIModel.TeamUIModel) -> UIViewController
}

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dependencies: LeaguesFlowCoordinatorDependencies
    
    private weak var leagueListVC: LeaguesViewController?

    init(navigationController: UINavigationController,
         dependencies: LeaguesFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = LeaguesViewModelActions(openCompetition: openTeams)
        
        let vc = dependencies.makeLeaguesListViewController(actions: actions)
        vc.title = "Football Leagues"
        navigationController.pushViewController(vc, animated: false)
        leagueListVC = vc
    }
    
    func openTeams(_ item: LeaguesUIModel.CompetitionUIModel) -> Void{
        let actions = TeamsViewModelActions(openTeamDetails: openTeamGames)
        let vc = dependencies.makeTeamsViewController(item, actions: actions)
        vc.title = item.name
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openTeamGames(item: TeamsUIModel.TeamUIModel){
        let vc = dependencies.makeTeamGamesViewController(item)
        vc.title = item.name
        navigationController.pushViewController(vc, animated: true)
    }
}
