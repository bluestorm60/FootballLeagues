//
//  TeamsResponseModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct TeamsResponseModel: Codable {
    let count: Int
    let filters: Filters
    let competition: Competition
    let season: Season
    let teams: [Team]

    struct Filters: Codable {
        let season: String
    }

    struct Competition: Codable {
        let id: Int
        let name: String
        let code: String
        let type: String
        let emblem: String
    }

    struct Season: Codable {
        let id: Int
        let startDate: String
        let endDate: String
        let currentMatchday: Int
        let winner: String?
    }

    struct Team: Codable {
        let area: Area?
        let id: Int
        let name: String
        let shortName: String
        let crest: String

        struct Area: Codable {
            let id: Int
            let name: String
            let code: String
            let flag: String?
        }
    }
}

