//
//  AppFlowCoordinator.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import UIKit

final class AppFlowCoordinator: Coordinator{

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let leaguesSceneDIContainer = appDIContainer.makeLeaguesSceneDIContainer()
        let flow =  leaguesSceneDIContainer.makeLeaguesFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
