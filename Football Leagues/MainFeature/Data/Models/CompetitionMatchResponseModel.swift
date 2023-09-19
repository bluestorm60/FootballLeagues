//
//  CompetitionMatchResponseModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct CompetitionMatchResponseModel: Codable {
    let filters: Filters
    let resultSet: ResultSet
    let competition: Competition

    struct Filters: Codable {
        let season: String
    }

    struct ResultSet: Codable {
        let count: Int
        let first: String
        let last: String
        let played: Int
    }

    struct Competition: Codable {
        let id: Int
        let name: String
        let code: String
        let type: String
        let emblem: String
    }
}
