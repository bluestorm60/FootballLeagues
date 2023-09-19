//
//  File.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct CompetitionMatchUIModel {
    let filters: FiltersUIModel
    let resultSet: ResultSetUIModel
    let competition: CompetitionUIModel

    struct FiltersUIModel {
        let season: String
    }

    struct ResultSetUIModel {
        let count: Int
        let first: String
        let last: String
        let played: Int
    }

    struct CompetitionUIModel {
        let id: Int
        let name: String
        let code: String
        let type: String
        let emblem: String
    }

    init(from responseModel: CompetitionMatchResponseModel) {
        self.filters = FiltersUIModel(season: responseModel.filters.season)
        self.resultSet = ResultSetUIModel(
            count: responseModel.resultSet.count,
            first: responseModel.resultSet.first,
            last: responseModel.resultSet.last,
            played: responseModel.resultSet.played
        )
        self.competition = CompetitionUIModel(
            id: responseModel.competition.id,
            name: responseModel.competition.name,
            code: responseModel.competition.code,
            type: responseModel.competition.type,
            emblem: responseModel.competition.emblem
        )
    }
}
