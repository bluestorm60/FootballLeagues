//
//  TeamMatchesTableViewCell.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import UIKit

class TeamMatchesTableViewCell: UITableViewCell {
    @IBOutlet weak var homeLogoImgeView: UIImageView!
    @IBOutlet weak var awayLogoImgeView: UIImageView!
    @IBOutlet weak var statusLabl: UILabel!
    @IBOutlet weak var scheduledDateLbl: UILabel!
    
    @IBOutlet weak var matchDateLbl: UILabel!
    
    var item: TeamMatchesCellViewModel?{
        didSet{
            configure(item)
        }
    }


    private func configure(_ item: TeamMatchesCellViewModel?){
        guard let item = item else {return}
        scheduledDateLbl.isHidden = item.isScheduledDateHidden()
        matchDateLbl.isHidden = !item.isScheduledDateHidden()
        scheduledDateLbl.text = item.getMatchDate()
        matchDateLbl.text = item.getMatchDate()
        homeLogoImgeView.load(with: item.getHomeLogo())
        awayLogoImgeView.load(with: item.getAwayLogo())
        statusLabl.text = item.getScore()
    }
}
