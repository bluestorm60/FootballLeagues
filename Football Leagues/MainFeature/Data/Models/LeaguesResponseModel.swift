//
//  LeaguesResponseModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation
struct LeaguesResponseModel: Codable {
    let count: Int
    let filters: Filters
    let competitions: [Competition]
    
    struct Filters: Codable {
        let client: String
    }
    
    struct Competition: Codable {
        let id: Int
        let area: Area
        let name: String
        let code: String
        let type: String
        let emblem: String
        let plan: String
        let currentSeason: Season
        let numberOfAvailableSeasons: Int
        let lastUpdated: String
    }
    
    struct Area: Codable {
        let id: Int
        let name: String
        let code: String
        let flag: String?
    }
    
    struct Season: Codable {
        let id: Int
        let startDate: String
        let endDate: String
        let currentMatchday: Int
        let winner: String?
    }
}
