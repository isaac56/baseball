//
//  ScoreViewController.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import UIKit
import Combine

class ScoreViewController: UIViewController {

    @IBOutlet weak var battingHistory: UITableView!
    
    private var gameHistoryViewModel = GameHistoryViewModel()
    private var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        battingHistory.dataSource = self
        battingHistory.register(BattingHistoryTableViewCell.nib(),
                                forCellReuseIdentifier: BattingHistoryTableViewCell.identifier)
        
        gameHistoryViewModel.$battingHistory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.battingHistory.reloadData()
            }
            .store(in: &cancelBag)
        
        gameHistoryViewModel.load()
    }

}

extension ScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameHistoryViewModel.battingHistory?.awayTeam.battingHistory.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BattingHistoryTableViewCell.identifier, for: indexPath) as? BattingHistoryTableViewCell else {
            return UITableViewCell()
        }
        guard let data = gameHistoryViewModel.battingHistory?.awayTeam.battingHistory[indexPath.row] else {
            return UITableViewCell()
        }
        let ratio = formatting(target: data.hitRatio)
        cell.configure(name: data.name, appearCount: data.appearCount, hits: data.hitCount, out: data.outCount, ratio: ratio)
        return cell
    }
    
    private func formatting(target: Double) -> String {
        return String(format: "%.1f",  target)
    }
}
