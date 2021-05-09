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
    var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RoomsViewModel()
        
        bind()
        viewModel.load()
        
        //print(viewModel.rooms)
    }
    
    func bind() {
        print("?")
        viewModel?.$rooms
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print(self.viewModel.rooms)
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] _ in
                    print(self?.viewModel.rooms)
                    self?.roomsTableView.reloadData()
                })
            .store(in: &self.cancelBag)
    }
}

extension LobbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableViewCell.identifier, for: indexPath) as? RoomTableViewCell else {
            return UITableViewCell()
        }
        
        let data = viewModel.rooms.data[indexPath.row]
        cell.fill(data: data)
        return cell
    }
}
