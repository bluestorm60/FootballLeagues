//
//  TeamsUIModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct TeamsUIModel {
    let count: Int
    let competition: CompetitionUIModel
    let teams: [TeamUIModel]

    struct CompetitionUIModel {
        let id: Int
        let name: String
        let code: String
        let type: String
        let emblem: String
    }

    struct TeamUIModel: Equatable{
        let id: Int
        let name: String
        let shortName: String
        let crest: String

        public static func == (lhs: TeamUIModel, rhs: TeamUIModel) -> Bool {
            return lhs.id == rhs.id &&
            lhs.name == rhs.name 
        }
    }
}

extension TeamsUIModel {
    init(from responseModel: TeamsResponseModel) {
        self.count = responseModel.count
        self.competition = CompetitionUIModel(from: responseModel.competition)
        self.teams = responseModel.teams.map { team in
            return TeamUIModel(from: team)
        }
    }
}

extension TeamsUIModel.CompetitionUIModel {
    init(from competition: TeamsResponseModel.Competition) {
        self.id = competition.id
        self.name = competition.name
        self.code = competition.code
        self.type = competition.type
        self.emblem = competition.emblem
    }
}

extension TeamsUIModel.TeamUIModel {
    init(from team: TeamsResponseModel.Team) {
        self.id = team.id
        self.name = team.name
        self.shortName = team.shortName
        self.crest = team.crest
    }
}



extension TeamsUIModel.TeamUIModel{
    init(from team: Team){
        self.id = Int(team.id)
        self.crest = team.crest ?? ""
        self.name = team.name ?? ""
        self.shortName = team.shortName ?? ""
    }
}
