//
//  TeamMatchesCellViewModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation

final class TeamMatchesCellViewModel{
    var item: TeamMatchesUIModel.Match
    
    init(_ item: TeamMatchesUIModel.Match) {
        self.item = item
    }
    
    func getHomeLogo() -> String?{
        return item.homeTeam.crest
    }
    
    func getAwayLogo() -> String?{
        return item.awayTeam.crest
    }

    func getScore() -> String{
        switch item.status{
        case .finished:
            return getScoreData()
        case .timed:
            return "Timed"
        case .scheduled:
            return "Scheduled"
        case .none:
            return "NA"
        }
    }
    
    func getMatchDate() -> String{
        return item.utcDate.reformatDate()
    }
    
    func isScheduledDateHidden() -> Bool{
        return item.status == .finished
    }
    
    private func getScoreData() -> String{
        if let homeScore = item.score?.fullTime?.home, let awayScore = item.score?.fullTime?.away{
            return "\(homeScore):\(awayScore)"
        }
        return "NA"
    }
    
    
}
