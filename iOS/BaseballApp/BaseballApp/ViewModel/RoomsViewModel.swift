//
//  RoomsViewModel.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation

class RoomsViewModel {
    @Published var rooms: RoomResponse = RoomResponse(data: []) {
        didSet {
            //print(rooms)
        }
    }
    let roomsUseCase = RoomsUseCase()
    
    func load() {
        guard let url = Endpoint.url(path: Endpoint.Path.gameList) else { return }
        roomsUseCase.start(url: url)
    }
}
