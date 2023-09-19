//
//  CompetitionListStubs.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
@testable import Football_Leagues

enum CompetitionListStubs {
    static func createLeagues() -> LeaguesResponseModel {
        let data = getJSON(bundle: Bundle.testBundle, for: "competitionList")
        let foods = parse(jsonData: data)
        return foods
    }
    
    static func getLeaguesData() -> Data? {
        let jsonData = try? JSONEncoder().encode(createLeagues())
        return jsonData
    }
    
    private static func parse(jsonData: Data) -> LeaguesResponseModel {
        let decodedData = try! JSONDecoder().decode(LeaguesResponseModel.self, from: jsonData)
        return decodedData
    }
}
