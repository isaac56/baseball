//
//  ScoreViewController.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import UIKit
import Combine

class ScoreViewController: UIViewController {

    @IBOutlet weak var segmentedTeam: UISegmentedControl!
    @IBOutlet weak var battingHistory: UITableView!
    
    @IBAction func selectTeam(_ sender: Any) {
        let index = segmentedTeam.selectedSegmentIndex
        guard let history = gameHistoryViewModel.battingHistory else {
            return
        }
        items = index == 0 ? history.awayTeam.battingHistory : history.homeTeam.battingHistory
        updateSnapshot()
    }
    
    private var gameHistoryViewModel = GameHistoryViewModel()
    private var cancelBag = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    private var items: [BattingHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        battingHistory.dataSource = dataSource
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

    func makeDataSource() -> UITableViewDiffableDataSource<Section, BattingHistory> {
        return UITableViewDiffableDataSource(tableView: battingHistory) { tableView, indexPath, model -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BattingHistoryTableViewCell.identifier,
                                                           for: indexPath) as? BattingHistoryTableViewCell else {
                return UITableViewCell()
            }
            let ratio = self.formatting(target: model.hitRatio)
            cell.configure(name: model.name, appearCount: model.appearCount, hits: model.hitCount, out: model.outCount, ratio: ratio)
            return cell
        }
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BattingHistory>()
        snapshot.appendSections([.one])
        snapshot.appendItems(items, toSection: .one)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    private func formatting(target: Double) -> String {
        return String(format: "%.1f",  target)
    }
}

//extension ScoreViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return gameHistoryViewModel.battingHistory?.awayTeam.battingHistory.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: BattingHistoryTableViewCell.identifier, for: indexPath) as? BattingHistoryTableViewCell else {
//            return UITableViewCell()
//        }
//        guard let history = gameHistoryViewModel.battingHistory else { return UITableViewCell() }
//        let targetTeam = segmentedTeam.selectedSegmentIndex == 0 ?  history.awayTeam : history.awayTeam
//        let data = targetTeam.battingHistory[indexPath.row]
//        let ratio = formatting(target: data.hitRatio)
//        cell.configure(name: data.name, appearCount: data.appearCount, hits: data.hitCount, out: data.outCount, ratio: ratio)
//        return cell
//    }
//}

enum Section {
    case one
}
