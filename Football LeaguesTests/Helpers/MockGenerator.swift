//
//  MockGenerator.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

struct MockGenerator {
    
    
    static func generateTeamsCellViewModels(count: Int, delegate: TeamsCellViewModelDelegate?) -> [TeamsCellViewModel]{
        let teamsList = MockGenerator.generateCompetitionTeams(count: 10)
        var list: [TeamsCellViewModel] = []
        for i in 1...count {
            let team = TeamsCellViewModel(teamsList[i - 1], delegate)
            list.append(team)
        }
        return list
    }

    static func generateCompetitionCellViewModels(count: Int, delegate: CompetitionCellViewModelDelegate?) -> [CompetitionCellViewModel]{
        let generateCompetitions = MockGenerator.generateCompetitions(count: count)
        var competitions: [CompetitionCellViewModel] = []
        for i in 1...count {
            let competition = CompetitionCellViewModel(generateCompetitions[i - 1], delegate)
            competitions.append(competition)
        }
        return competitions
    }
    
    static func generateLeaguesUIModel(count: Int) -> LeaguesUIModel{
        return LeaguesUIModel(count: count, competitions: MockGenerator.generateCompetitions(count: count))
    }
    
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

    static func generateCompetitionsResponse(count: Int) -> LeaguesResponseModel{
        var list = [LeaguesResponseModel.Competition]()
        for i in 1...count{
            let competition = LeaguesResponseModel.Competition(id: i,
                            area: LeaguesResponseModel.Area(id: i, name: "name\(i)", code: "code\(i)", flag: "flag\(i)"),
                            name: "name\(i)",
                            code: "code\(i)",
                            type: "type\(i)",
                            emblem: "https://crests.football-data.org/1765.svg",
                            plan: "plan\(i)",
                            currentSeason: LeaguesResponseModel.Season(id: i, startDate: "startDate\(i)", endDate: "endDate\(i)", currentMatchday: i, winner: "winner\(i)"),
                            numberOfAvailableSeasons: i,
                            lastUpdated: "lastUpdated\(i)")
            list.append(competition)
        }
        return .init(count: count, filters: LeaguesResponseModel.Filters(client: "client \(count)"), competitions: list)
    }
    
    static func generateTeamsResponseModel(count: Int) -> TeamsResponseModel{
        var list = [TeamsResponseModel.Team]()
        for i in 1...count{
            let team = TeamsResponseModel.Team(area: nil, id: i, name: "name\(i)", shortName: "shortName\(i)", crest: "https://crests.football-data.org/1765.svg")
            list.append(team)
        }
        return .init(count: count, filters: TeamsResponseModel.Filters(season: ""), competition: TeamsResponseModel.Competition(id: 1, name: "name1", code: "code1", type: "type", emblem: "https://crests.football-data.org/1765.svg"), season: TeamsResponseModel.Season(id: 1, startDate: "", endDate: "", currentMatchday: 1, winner: nil), teams: list)

    }
    
    static func generateCompetitionMatchResponseModel(count: Int) -> CompetitionMatchResponseModel{
        return CompetitionMatchResponseModel(filters: CompetitionMatchResponseModel.Filters(season: ""), resultSet: CompetitionMatchResponseModel.ResultSet(count: count, first: "first", last: "last", played: count), competition: CompetitionMatchResponseModel.Competition(id: 1, name: "name 1", code: "code1", type: "", emblem: "https://crests.football-data.org/1765.svg"))
    }
}


