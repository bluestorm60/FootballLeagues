//
//  TeamMatchesResponseModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct TeamMatchesResponseModel: Codable {
    let filters: Filters
    let resultSet: ResultSet
    let competition: Competition?
    let matches: [Match]

    struct Filters: Codable {
        let competitions: String
        let permission: String
        let limit: Int
    }

    struct ResultSet: Codable {
        let count: Int
        let competitions: String
        let first: String
        let last: String
        let played: Int
        let wins: Int
        let draws: Int
        let losses: Int
    }

    struct Competition: Codable {
        let id: Int?
        let name: String?
        let code: String?
        let type: String?
        let emblem: String?
    }

    struct Match: Codable {
        let area: Area
        let competition: Competition
        let season: Season
        let id: Int
        let utcDate: String
        let status: String
        let matchday: Int
        let stage: String
        let group: String?
        let lastUpdated: String
        let homeTeam: Team
        let awayTeam: Team
        let score: Score

        struct Area: Codable {
            let id: Int
            let name: String
            let code: String
            let flag: String
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
            let id: Int
            let name: String
            let shortName: String
            let tla: String
            let crest: String
        }

        struct Score: Codable {
            let winner: String?
            let duration: String
            let fullTime: ScoreDetail
            let halfTime: ScoreDetail

            struct ScoreDetail: Codable {
                let home: Int?
                let away: Int?
            }
        }
    }
}
