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
    
    func configureTeamNames(away: String, home: String) {
        awayTeamName.text = away
        homeTeamName.text = home
    }
    
    func configureAway(score: Int) {
        awayTeamScore.text = "\(score)"
    }
    
    func configureHome(score: Int) {
        homeTeamScore.text = "\(score)"
    }
}
