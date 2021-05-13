//
//  BattingHistoryTableViewCell.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import UIKit

class BattingHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var batter: UILabel!
    @IBOutlet weak var appearCount: UILabel!
    @IBOutlet weak var hits: UILabel!
    @IBOutlet weak var out: UILabel!
    @IBOutlet weak var average: UILabel!

    static func nib() -> UINib {
        return UINib(nibName: BattingHistoryTableViewCell.identifier, bundle: nil)
    }
    
    func configure(model: BattingHistoryTableViewCellModel) {
        batter.text = model.name
        self.appearCount.text = "\(model.appearCount)"
        self.hits.text = "\(model.hits)"
        self.out.text = "\(model.out)"
        self.average.text = model.ratio
        self.backgroundColor = model.isPlaying ? .systemBlue : .clear
    }
}

struct BattingHistoryTableViewCellModel {
    let name: String?
    let appearCount: Int
    let hits: Int
    let out: Int
    let ratio: String?
    let isPlaying: Bool
}
