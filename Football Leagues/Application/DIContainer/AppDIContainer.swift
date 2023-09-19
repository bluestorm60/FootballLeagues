//
//  AppDIContainer.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 10/09/2023.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    lazy var apiDataTransferService: NetworkProtocol = { return Network.shared } ()

    // MARK: - DIContainers of scenes
    func makeLeaguesSceneDIContainer() -> LeaguesDIContainer {
        let dependencies = LeaguesDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return LeaguesDIContainer(dependencies: dependencies)
    }
}
