//
//  TeamCellViewModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import Foundation

protocol TeamsCellViewModelDelegate: AnyObject{
    func openTeamDetails(item: TeamsUIModel.TeamUIModel?)
}

final class TeamsCellViewModel{
    var item: TeamsUIModel.TeamUIModel
    weak var delegate: TeamsCellViewModelDelegate?
    
    init(_ item: TeamsUIModel.TeamUIModel,_ delegate: TeamsCellViewModelDelegate?) {
        self.item = item
        self.delegate = delegate
    }
    
    func getImgeUrl() -> String?{
        return item.crest
    }
    
    func getTeamName() -> String{
        return item.name
    }
}
