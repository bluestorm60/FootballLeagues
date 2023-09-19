//
//  TeamsTableViewCell.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import UIKit

class TeamsTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet private weak var commonLeagueView: CommonLeagueView!

    //MARK: - Properties
    var item: TeamsCellViewModel?{
        didSet{
            configure(item)
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func configure(_ item: TeamsCellViewModel?){
        guard let item = item else {return}
        commonLeagueView.actionClicked = { [weak self] in
            guard let self else {return}
            item.delegate?.openTeamDetails(item: item.item)
        }
        commonLeagueView.item =
            .init(name: item.getTeamName(), logo: item.getImgeUrl())
    }

}
