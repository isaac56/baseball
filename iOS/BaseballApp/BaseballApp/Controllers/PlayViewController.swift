//
//  PlayViewController.swift
//  BaseballApp
//
//  Created by Song on 2021/05/04.
//

import UIKit
import Combine

class PlayViewController: UIViewController {
    enum Constant {
        static let tableRowHeight: CGFloat = 44.0
        static let currentPlayerViewHeight: CGFloat = 100.0
    }
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var playInformationStackView: UIStackView!
    @IBOutlet weak var scoreHeaderView: ScoreHeaderView!
    
    var currentPlayerView: CurrentPlayerView!
    var groundView: GroundView!
    var count: Int = 0
    var viewModel: GameViewModel = GameViewModel()
    var cancelBag = Set<AnyCancellable>()
    
    private let pitcherHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = Constant.tableRowHeight
        tableView.register(PitcherRecordTableViewCell.nib(), forCellReuseIdentifier: PitcherRecordTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pitcherHistoryTableView.dataSource = self

        viewModel.$game
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let game = response?.data else { return }
                self?.scoreHeaderView.configureAway(score: game.awayTeam.score)
                self?.scoreHeaderView.configureHome(score: game.homeTeam.score)
                self?.currentPlayerView.configure(batter: game.batter, status: game.batterStatus)
                self?.currentPlayerView.configure(pitcher: game.pitcher, status: game.pitcherStatus)
                self?.currentPlayerView.configure(playerRole: game.myRole)
                self?.pitcherHistoryTableView.reloadData()
            }
            .store(in: &cancelBag)
        
        configureUI()
        viewModel.load()
    }
    
    private func configureUI() {
        guard let groundView = Bundle.main.loadNibNamed(GroundView.identifier,
                                                        owner: self,
                                                        options: nil)?.first as? GroundView,
              let currentPlayerView = Bundle.main.loadNibNamed(CurrentPlayerView.identifier,
                                                               owner: self,
                                                               options: nil)?.first as? CurrentPlayerView else {
            return
        }
        self.currentPlayerView = currentPlayerView
        self.groundView = groundView
        groundView.delegate = self
        
        playInformationStackView.addArrangedSubview(groundView)
        playInformationStackView.addArrangedSubview(currentPlayerView)
        playInformationStackView.addArrangedSubview(pitcherHistoryTableView)
        
        NSLayoutConstraint.activate([
            groundView.heightAnchor.constraint(equalToConstant: view.frame.width),
            currentPlayerView.heightAnchor.constraint(equalToConstant: Constant.currentPlayerViewHeight),
            pitcherHistoryTableView.heightAnchor.constraint(equalToConstant: Constant.tableRowHeight * CGFloat(500)),
            pitcherHistoryTableView.leadingAnchor.constraint(equalTo: playInformationStackView.leadingAnchor),
            pitcherHistoryTableView.trailingAnchor.constraint(equalTo: playInformationStackView.trailingAnchor),
        ])
    }
}

extension PlayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.game?.data.pitchHistories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PitcherRecordTableViewCell.identifier, for: indexPath) as? PitcherRecordTableViewCell,
              let record = viewModel.game?.data.pitchHistories[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(number: indexPath.row + 1, record: record)
        return cell
    }
}

extension PlayViewController: GroundViewDelegate {
    func pitch() {
        viewModel.requestPitch()
    }
}