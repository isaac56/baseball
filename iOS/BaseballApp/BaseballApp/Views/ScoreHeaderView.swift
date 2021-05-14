//
//  HeaderView.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/05.
//

import UIKit

class ScoreHeaderView: UIView {

    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamScore: UILabel!
    @IBOutlet weak var homeTeamScore: UILabel!
    
    func configureNames(with away: String, _ home: String) {
        awayTeamName.text = away
        homeTeamName.text = home
    }
    
    func configureAway(score: Int) {
        awayTeamScore.text = "\(score)"
    }
    
    func configureHome(score: Int) {
        homeTeamScore.text = "\(score)"
    }
    
    func configure(awayTeam: Team) {
        if awayTeam.role == Role.attack.rawValue {
            self.awayTeamName.textColor = .systemRed
            self.homeTeamName.textColor = .black
        } else {
            self.homeTeamName.textColor = .systemRed
            self.awayTeamName.textColor = .black
        }
    }
}
