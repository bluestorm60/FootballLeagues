//
//  MockMainCoordinator.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import Foundation
@testable import Football_Leagues

class MockMainCoordinator: MainCoordinator {
    var openTeamsCalled = false
    var openTeamGamesCalled = false

    override func openTeams(_ competition: LeaguesUIModel.CompetitionUIModel, _ useCase: LeaguesUseCase) {
        openTeamsCalled = true
    }
    
    override func openTeamGames(item: TeamsUIModel.TeamUIModel) {
        openTeamGamesCalled = true
    }
}
