//
//  GameHistoryViewModel.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import Foundation
import Combine

class GameHistoryViewModel {
    @Published var battingHistory: BattingHistoryData?
    var awayBbattingHistory: [BattingHistory] {
        return battingHistory?.awayTeam.battingHistory ?? []
    }
    var homeBbattingHistory: [BattingHistory] {
        return battingHistory?.homeTeam.battingHistory ?? []
    }
    private let gameHistoryUseCase = GameHistoryUseCase()
    private var cancelBag = Set<AnyCancellable>()
    
    func load() {
        guard let url = Endpoint.url(path: Endpoint.Path.gameHistory) else { return }
        let publisher = gameHistoryUseCase.start(url: url)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { (response) in
            self.battingHistory = response.data
        }
        .store(in: &cancelBag)
    }
}
