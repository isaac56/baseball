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
    
    func configure(name: String, appearCount: Int, hits: Int, out: Int, ratio: String) {
        batter.text = name
        self.appearCount.text = "\(appearCount)"
        self.hits.text = "\(hits)"
        self.out.text = "\(out)"
        self.average.text = ratio
    }
}
