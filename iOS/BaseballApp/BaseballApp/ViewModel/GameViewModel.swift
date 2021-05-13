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
    
    func load() {
        guard let url = Endpoint.url(path: Endpoint.Path.gameStatus) else { return }
        let publisher = gameUseCase.start(url: url)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] (response) in
            self?.game = response
        }
        .store(in: &cancelBag)
    }
    
    func requestPitch() {
        guard let url = Endpoint.url(path: Endpoint.Path.pitchResult) else { return }
        let publisher = gameUseCase.pitch(url: url)
        publisher.sink { [weak self] (completion) in
            switch completion {
            case .finished:
                self?.load()
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { _ in }
        .store(in: &cancelBag)
    }
}
