//
//  LeagueTableViewCell.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 14/09/2023.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var commonLeagueView: CommonLeagueView!

    //MARK: - Properties
    var item: CompetitionCellViewModel?{
        didSet{
            configure(item)
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        commonLeagueView.isUserInteractionEnabled = true
    }

    private func configure(_ item: CompetitionCellViewModel?){
        guard let item = item else {return}
        commonLeagueView.actionClicked = {
            item.delegate?.openCompetition(item: item.item)
        }
        commonLeagueView.item =
            .init(name: item.getCompetitionName(), logo: item.getImgeUrl(),isDetailsHidden: false, seasonsNumber: item.getCompetitionSeasonsCount(), matchesNumber: item.getCompetitionMatchesCount(), teamsNumber: item.getCompetitionTeamsCount())
    }
}

