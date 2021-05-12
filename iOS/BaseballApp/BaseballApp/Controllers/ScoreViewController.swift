//
//  ScoreViewController.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import UIKit
import Combine

class ScoreViewController: UIViewController {
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayScoreStackView: UIStackView!
    @IBOutlet weak var homeScoreStackView: UIStackView!
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
            .sink { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.awayTeamName.text = data?.awayTeam.teamName
                strongSelf.homeTeamName.text = data?.homeTeam.teamName
                strongSelf.setScore(for: strongSelf.homeScoreStackView, of: data?.awayTeam.scores)
                strongSelf.setScore(for: strongSelf.awayScoreStackView, of: data?.homeTeam.scores)
                strongSelf.battingHistory.reloadData()
            }
            .store(in: &cancelBag)
        gameHistoryViewModel.load()
    }

    // MARK: Private Functions
    private func setScore(for team: UIStackView, of numbers: [Int]?) {
        guard let numbers = numbers else {
            return
        }
        numbers.forEach { number in
            let label = UILabel()
            label.font = UIFont(name: "Helvetica", size: 14)
            label.text = "\(number)"
            team.addArrangedSubview(label)
        }
    }
    
    
    // MARK: UITableViewDiffableDataSource
    
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

enum Section {
    case one
}
