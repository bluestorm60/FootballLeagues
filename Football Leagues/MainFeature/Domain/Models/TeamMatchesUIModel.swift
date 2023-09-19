//
//  TeamMatchesUIModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation

struct TeamMatchesUIModel {
    let matches: [Match]

    struct Match {
        let id: Int
        let status: MatchStatus
        let utcDate: String
        let homeTeam: TeamInfo
        let awayTeam: TeamInfo
        let score: Score?
        
        enum MatchStatus: String{
            case finished = "FINISHED"
            case scheduled = "SCHEDULED"
            case timed = "TIMED"
            case none
        }
    }

    struct TeamInfo {
        let id: Int
        let name: String
        let shortName: String?
        let tla: String?
        let crest: String?
    }

    struct Score {
        let fullTime: FullTimeScore?
    }

    struct FullTimeScore{
        let home: Int?
        let away: Int?
    }
}
extension TeamMatchesUIModel.FullTimeScore{
    init(from item: TeamMatchesResponseModel.Match.Score.ScoreDetail){
        self.home = item.home
        self.away = item.away
    }
}

extension TeamMatchesUIModel.Score{
    init(from item: TeamMatchesResponseModel.Match.Score.ScoreDetail){
        self.fullTime = .init(from: item)
    }
}

extension TeamMatchesUIModel.TeamInfo{
    init(from item: TeamMatchesResponseModel.Match.Team){
        self.crest = item.crest
        self.id = item.id
        self.name = item.name
        self.shortName = item.shortName
        self.tla = item.tla
    }
}

extension TeamMatchesUIModel.Match{
    init(from item: TeamMatchesResponseModel.Match) {
        self.id = item.id
        self.awayTeam = .init(from: item.awayTeam)
        self.homeTeam = .init(from: item.homeTeam)
        self.score = .init(from: item.score.fullTime)
        self.status = MatchStatus(rawValue: item.status) ?? .none
        self.utcDate = item.utcDate
    }
}
