//
//  PitcherHistoryTableViewCell.swift
//  BaseballApp
//
//  Created by Song on 2021/05/04.
//

import UIKit

class PitcherRecordTableViewCell: UITableViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var count: UILabel!

    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        number.layer.masksToBounds = true
        number.layer.cornerRadius = number.frame.width / 2
    }
    
    func configure(number: Int, record: Record) {
        self.number.text = "\(number)"
        result.text = record.result
        let strike = record.strikeCount
        let ball = record.ballCount
        count.text = "\(strike)-\(ball)"
    }
}
