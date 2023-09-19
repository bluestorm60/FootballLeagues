//
//  StubsModels.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

struct StubsModels {
    static func generateCompetitions(count: Int) -> [LeaguesUIModel.CompetitionUIModel] {
        
        var competitions: [LeaguesUIModel.CompetitionUIModel] = []

        for i in 1...count {
            let competition = LeaguesUIModel.CompetitionUIModel(
                id: i,
                name: "Competition \(i)",
                areaName: "Area \(i)",
                code: "Code\(i)",
                type: "Type \(i)",
                emblem: "https://crests.football-data.org/764.svg",
                numberOfmatches: "\(i)",
                numberOfTeams: "\(i)",
                numberOfSeasons: "\(i)"
            )

            competitions.append(competition)
        }

        return competitions
    }
    
    static func generateCompetitionTeams(count: Int) -> [TeamsUIModel.TeamUIModel] {
        var teams: [TeamsUIModel.TeamUIModel] = []

        for i in 1...count {
            let team = TeamsUIModel.TeamUIModel(id: i,
                                                name: "Team \(i)",
                                                shortName: "shortName \(i)",
                                                crest: "https://crests.football-data.org/1765.svg")

            teams.append(team)
        }

        return teams
    }

    static func getTeamGamesResponse() -> TeamMatchesResponseModel?{
        let data = getJSON(bundle: Bundle.testBundle, for: "teamMatches")
        do{
            let response = try JSONDecoder().decode(TeamMatchesResponseModel.self, from: data)
            return response
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
}
