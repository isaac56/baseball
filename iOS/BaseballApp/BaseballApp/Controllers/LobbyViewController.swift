//
//  ViewController.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/04.
//

import UIKit
import Combine

class LobbyViewController: UIViewController {

    @IBOutlet weak var roomsTableView: UITableView!
    var viewModel: RoomsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        
        viewModel = RoomsViewModel()
        viewModel.load {
            DispatchQueue.main.async {
                self.roomsTableView.reloadData()
            }
        }
    }
}

extension LobbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rooms.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableViewCell.identifier, for: indexPath) as? RoomTableViewCell else {
            return UITableViewCell()
        }
        
        guard let data = viewModel.rooms.data?[indexPath.row] else { return UITableViewCell() }
        let viewModel = RoomTableViewCellViewModel(roomNumber: "\(data.id)", awayTeamName: data.awayTeam!, homeTeamName: data.homeTeam!)
        cell.fill(with: viewModel)
        return cell
    }
}

extension LobbyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "PlayViewController"),
              let data = viewModel.rooms.data?[indexPath.row] else { return }

        let menu = UIAlertController(title: nil, message: "참가할 팀을 고르세요", preferredStyle: .actionSheet)

        let chooseAway = UIAlertAction(title: data.awayTeam, style: .default) { (_) in
            self.viewModel.join(id: data.id, venue: .home) { [weak self] in
                DispatchQueue.main.async {
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
        }
        let chooseHome = UIAlertAction(title: data.homeTeam, style: .default) { (_) in
            self.viewModel.join(id: data.id, venue: .home) { [weak self] in
                DispatchQueue.main.async {
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        menu.addAction(chooseAway)
        menu.addAction(chooseHome)
        menu.addAction(cancel)
        
        self.present(menu, animated: true, completion: nil)
        
        // solve autolayout constraint break
        menu.view.subviews.flatMap({$0.constraints}).filter{ (one: NSLayoutConstraint)-> (Bool)  in
            return (one.constant < 0) && (one.secondItem == nil) &&  (one.firstAttribute == .width)
        }.first?.isActive = false
        
        // for check
        print(data.id)
    }
}
