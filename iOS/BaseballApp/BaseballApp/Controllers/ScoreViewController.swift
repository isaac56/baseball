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
    
    private var gameHistoryViewModel = GameHistoryViewModel()
    private var cancelBag = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    private var items: [BattingHistory] = []
    private var header: ScoreHeaderView? = UIView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = header
        setupTableView()
        bind()
        gameHistoryViewModel.load()
    }

    // MARK: Private Functions
    
    private func bind() {
        gameHistoryViewModel.$battingHistory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.header?.awayTeamScore.text = strongSelf.reduce(for: data?.awayTeam.scores).toString()
                strongSelf.header?.homeTeamScore.text = strongSelf.reduce(for: data?.homeTeam.scores).toString()
                strongSelf.header?.awayTeamName.text = data?.awayTeam.teamName
                strongSelf.header?.homeTeamName.text = data?.homeTeam.teamName
                strongSelf.segmentedTeam.setTitle(data?.awayTeam.teamName, forSegmentAt: 0)
                strongSelf.segmentedTeam.setTitle(data?.homeTeam.teamName, forSegmentAt: 1)
                strongSelf.awayTeamName.text = data?.awayTeam.teamName
                strongSelf.homeTeamName.text = data?.homeTeam.teamName
                strongSelf.setScore(for: strongSelf.awayScoreStackView, of: data?.awayTeam.scores)
                strongSelf.setScore(for: strongSelf.homeScoreStackView, of: data?.homeTeam.scores)
                strongSelf.items = data?.awayTeam.battingHistory ?? []
                strongSelf.calculateTotalAway()
                strongSelf.updateSnapshot()
            }
            .store(in: &cancelBag)
    }
    
    private func setupTableView() {
        battingHistory.delegate = self
        battingHistory.dataSource = dataSource
        battingHistory.register(BattingHistoryTableViewCell.nib(),
                                forCellReuseIdentifier: BattingHistoryTableViewCell.identifier)
        battingHistory.rowHeight = 30
        battingHistory.sectionHeaderHeight = 30
    }
    
    private func setScore(for team: UIStackView, of numbers: [Int]?) {
        guard let numbers = numbers else {
            return
        }
        numbers.forEach { number in
            let label = UILabel()
            label.widthAnchor.constraint(equalToConstant: 15).isActive = true
            label.font = UIFont(name: "Helvetica", size: 13)
            label.text = "\(number)"
            label.textAlignment = .center
            team.addArrangedSubview(label)
        }
    }
    
    private func reduce(for data: [Int]?) -> Int {
        guard let data = data else {
            return 0
        }
        return data.reduce(0) { $0 + $1 }
    }
    
    // MARK: UITableViewDiffableDataSource
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, BattingHistory> {
        return UITableViewDiffableDataSource(tableView: battingHistory) { tableView, indexPath, model -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BattingHistoryTableViewCell.identifier,
                                                           for: indexPath) as? BattingHistoryTableViewCell else {
                return UITableViewCell()
            }
            let ratio = self.formatting(target: model.hitRatio)
            let cellModel = BattingHistoryTableViewCellModel(name: model.name, appearCount: model.appearCount, hits: model.hitCount, out: model.outCount, ratio: ratio, isPlaying: model.playing)
            cell.configure(model: cellModel)
            return cell
        }
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BattingHistory>()
        snapshot.appendSections([.one])
        snapshot.appendItems(items, toSection: .one)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    private func formatting(target: Double?) -> String? {
        guard let target = target else {
            return nil
        }
        return String(format: "%.1f",  target)
    }
    
    private func calculateTotalAway() {
        let total = BattingHistory(uniformNumber: 0, name: "Total", appearCount: gameHistoryViewModel.awayTotalAppearCount, hitCount: gameHistoryViewModel.awayTotalHits, outCount: gameHistoryViewModel.awayTotalOut, hitRatio: nil, playing: false)
        items.append(total)
    }
    
    private func calculateTotalHome() {
        let total = BattingHistory(uniformNumber: 0, name: "Total", appearCount: gameHistoryViewModel.homeTotalAppearCount, hitCount: gameHistoryViewModel.homeTotalHits, outCount: gameHistoryViewModel.homeTotalOut, hitRatio: nil, playing: false)
        items.append(total)
    }
    
    // MARK: IBAction
    
    @IBAction func selectTeam(_ sender: Any) {
        if segmentedTeam.selectedSegmentIndex == 0 {
            items = gameHistoryViewModel.awayBattingHistory
            calculateTotalAway()
        } else {
            items = gameHistoryViewModel.homeBattingHistory
            calculateTotalHome()
        }
        updateSnapshot()
    }
}

extension ScoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = Bundle.main.loadNibNamed(BattingHistoryTableViewCell.identifier,
                                                    owner: self,
                                                    options: nil)?.first as? BattingHistoryTableViewCell else {
            return nil
        }
        header.backgroundColor = .systemGray
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

enum Section {
    case one
}

extension Int {
    func toString() -> String {
        return "\(self)"
    }
}
