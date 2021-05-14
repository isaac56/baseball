//
//  CurrentPlayerView.swift
//  BaseballApp
//
//  Created by Song on 2021/05/04.
//

import UIKit

class CurrentPlayerView: UIView {
    @IBOutlet weak var pitcher: UILabel!
    @IBOutlet weak var pitcherStatus: UILabel!
    @IBOutlet weak var isPitcher: UIImageView!
    @IBOutlet weak var batter: UILabel!
    @IBOutlet weak var batterStatus: UILabel!
    @IBOutlet weak var isBatter: UIImageView!
    
    func configure(pitcher: Player, status: String) {
        self.pitcher.text = pitcher.name
        self.pitcherStatus.text = status
    }
    
    func configure(batter: Player, status: String) {
        self.batter.text = batter.name
        self.batterStatus.text = status
    }
    
    func configure(playerRole: String) {
        if playerRole == Role.defense.rawValue {
            isBatter.isHidden = true
            isPitcher.isHidden = false
        } else {
            isBatter.isHidden = false
            isPitcher.isHidden = true
        }
    }
}

enum Role: String {
    case defense = "DEFENSE"
    case attack = "ATTACK"
}
