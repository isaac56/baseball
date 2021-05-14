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
    @IBOutlet weak var scoreHeaderView: UIView!
    
    var currentPlayerView: CurrentPlayerView!
    var groundView: GroundView!
    var header: ScoreHeaderView? = UIView.loadFromNib()
    var viewModel: GameViewModel = GameViewModel()
    var cancelBag = Set<AnyCancellable>()
    
    lazy var handler: (CustomError) -> Void = {
        switch $0 {
        case .badRequest:
            self.moveToLogin()
        }
    }
    
    private let pitcherHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = Constant.tableRowHeight
        tableView.register(PitcherRecordTableViewCell.nib(), forCellReuseIdentifier: PitcherRecordTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.completionHandler = handler
        header?.frame = scoreHeaderView.bounds
        guard let header = header else { return }
        scoreHeaderView.addSubview(header)
        pitcherHistoryTableView.dataSource = self

        viewModel.$game
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let game = response?.data else { return }
                guard let strongSelf = self else { return }
                strongSelf.header?.configure(awayTeam: game.awayTeam)
                strongSelf.header?.configureNames(with: game.awayTeam.name, game.homeTeam.name)
                strongSelf.header?.configureAway(score: game.awayTeam.score)
                strongSelf.header?.configureHome(score: game.homeTeam.score)
                strongSelf.currentPlayerView.configure(batter: game.batter, status: game.batterStatus)
                strongSelf.currentPlayerView.configure(pitcher: game.pitcher, status: game.pitcherStatus)
                strongSelf.currentPlayerView.configure(playerRole: game.myRole)
                strongSelf.groundView.configure(inningInfo: strongSelf.viewModel.convert(inning: game.inning, halves: game.halves))
                strongSelf.groundView.configure(myRole: strongSelf.viewModel.convert(myRole: game.myRole))
                strongSelf.groundView.configure(strikeCount: game.strike)
                strongSelf.groundView.configure(ballCount: game.ball)
                strongSelf.groundView.configure(outCount: game.out)
                NSLayoutConstraint.deactivate(strongSelf.pitcherHistoryTableView.constraints)
                let heightConstraint = NSLayoutConstraint(item: strongSelf.pitcherHistoryTableView as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: Constant.tableRowHeight * CGFloat(game.pitchHistories.count))
                strongSelf.pitcherHistoryTableView.addConstraint(heightConstraint)
                strongSelf.pitcherHistoryTableView.reloadData()
            }
            .store(in: &cancelBag)
        
        viewModel.$isBatterChanged
            .receive(on: DispatchQueue.main)
            .zip(viewModel.$game)
            .sink { [weak self] response in
                if response.0 {
                    self?.groundView.moveRunners()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.groundView.showRunners()
                        self?.groundView.configureBatterLayer(with: response.1?.data.batter.uniformNumber ?? 0)
                        self?.groundView.configureRunner1Layer(with: response.1?.data.base1?.uniformNumber)
                        self?.groundView.configureRunner2Layer(with: response.1?.data.base2?.uniformNumber)
                        self?.groundView.configureRunner3Layer(with: response.1?.data.base3?.uniformNumber)
                    }
                } else {
                    self?.groundView.configureBatterLayer(with: response.1?.data.batter.uniformNumber ?? 0)
                    self?.groundView.configureRunner1Layer(with: response.1?.data.base1?.uniformNumber)
                    self?.groundView.configureRunner2Layer(with: response.1?.data.base2?.uniformNumber)
                    self?.groundView.configureRunner3Layer(with: response.1?.data.base3?.uniformNumber)
                }
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
              let pitchHistories = viewModel.game?.data.pitchHistories else {
            return UITableViewCell()
        }
        let record = pitchHistories.reversed()[indexPath.row]
        let count = pitchHistories.count
        cell.configure(number: count - indexPath.row, record: record)
        return cell
    }
}

extension PlayViewController: GroundViewDelegate {
    func pitch() {
        viewModel.requestPitch()
    }
}

extension PlayViewController {
    func moveToLogin() {
        DispatchQueue.main.async { [weak self] in
            guard let login = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") else {
                return
            }
            login.modalPresentationStyle = .fullScreen
            self?.present(login, animated: true)
        }
    }
}
