//
//  LeaguesCellViewModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import Foundation

protocol CompetitionCellViewModelDelegate: AnyObject{
    func openCompetition(item: LeaguesUIModel.CompetitionUIModel?)
}

final class CompetitionCellViewModel{
    var item: LeaguesUIModel.CompetitionUIModel
    weak var delegate: CompetitionCellViewModelDelegate?
    
    init(_ item: LeaguesUIModel.CompetitionUIModel,_ delegate: CompetitionCellViewModelDelegate?) {
        self.item = item
        self.delegate = delegate
    }
    
    func getImgeUrl() -> String?{
        return item.emblem
    }
    
    func getCompetitionName() -> String{
        return item.name
    }
    
    func getCompetitionSeasonsCount() -> String{
        return item.numberOfSeasons
    }
    
    func getCompetitionTeamsCount() -> String{
        return item.numberOfTeams
    }
    
    func getCompetitionMatchesCount() -> String{
        return item.numberOfmatches
    }
}
