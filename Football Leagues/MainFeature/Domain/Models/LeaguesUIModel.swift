//
//  File.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct LeaguesUIModel {
    let count: Int
    var competitions: [CompetitionUIModel]
    struct CompetitionUIModel: Equatable{
        let id: Int
        let name: String
        let areaName: String
        let code: String
        let type: String
        let emblem: String
        var numberOfmatches: String = "NA"
        var numberOfTeams: String = "NA"
        var numberOfSeasons: String = "NA"
        
        public static func == (lhs: LeaguesUIModel.CompetitionUIModel, rhs: LeaguesUIModel.CompetitionUIModel) -> Bool {
            return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.code == rhs.code
        }
    }
    
    init(from responseModel: LeaguesResponseModel) {
        self.count = responseModel.count
        self.competitions = responseModel.competitions.map { competition in
            return CompetitionUIModel(
                id: competition.id,
                name: competition.name,
                areaName: competition.area.name,
                code: competition.code,
                type: competition.type,
                emblem: competition.emblem,
                numberOfSeasons: "\(competition.numberOfAvailableSeasons)"
            )
        }
    }
}

extension LeaguesUIModel {
    init(count: Int? = 0, competitions: [CompetitionUIModel]? = []){
        self.count = count ?? 0
        self.competitions = competitions ?? []
    }
}

extension LeaguesUIModel.CompetitionUIModel{
    init(from model: TeamsUIModel.CompetitionUIModel) {
        self.areaName = model.name
        self.code = model.code
        self.emblem = model.emblem
        self.id = model.id
        self.name = model.name
        self.type = model.type
    }
}
