//
//  RoomsViewModel.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation
import Combine

class RoomsViewModel {
    @Published var rooms: RoomResponse = RoomResponse(data: [], error: "")
    var cancelBag = Set<AnyCancellable>()
    let roomsUseCase = RoomsUseCase()
        
    func load(completionHandler: @escaping () -> Void) {
        guard let url = Endpoint.url(path: Endpoint.Path.gameList) else { return }
        let publisher = roomsUseCase.start(url: url)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                completionHandler()
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { (response) in
            self.rooms = response
        }
        .store(in: &cancelBag)
    }
    
    func join(id: Int, venue: Venue, completionHandler: @escaping () -> Void) {
        guard let url = Endpoint.url(path: Endpoint.Path.join) else { return }
        let publisher = roomsUseCase.join(url: url, gameId: id, venue: venue)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                completionHandler()
            case .failure(let error):
                print(error)
            }
        } receiveValue: { (response) in
        }
        .store(in: &cancelBag)
    }
}
