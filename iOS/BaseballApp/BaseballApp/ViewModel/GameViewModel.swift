//
//  GameViewModel.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/05.
//

import Foundation
import Combine

class GameViewModel {
    @Published var game: GameResponse?
    let gameUseCase = GameUseCase()
    var cancelBag = Set<AnyCancellable>()
    var handler: ((Game) -> Void)?
    
    func load(completionHandler: @escaping (Game) -> Void) {
        guard let url = Endpoint.url(path: Endpoint.Path.gameStatus) else { return }
        let publisher = gameUseCase.start(url: url)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { (response) in
            self.game = response
            completionHandler(response.data)
        }
        .store(in: &cancelBag)
    }
    
    func requestPitch() {
        guard let handler = handler else { return }
        guard let url = Endpoint.url(path: Endpoint.Path.pitchResult) else { return }
        let publisher = gameUseCase.pitch(url: url)
        publisher.sink { [weak self] (completion) in
            switch completion {
            case .finished:
                self?.load(completionHandler: handler)
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { _ in }
        .store(in: &cancelBag)
    }
}
