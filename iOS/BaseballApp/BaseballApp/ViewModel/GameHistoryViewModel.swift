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

extension GameHistoryViewModel {
    var awayBattingHistory: [BattingHistory] {
        return battingHistory?.awayTeam.battingHistory ?? []
    }

    var awayTotalAppearCount: Int {
        var total = 0
        self.awayBattingHistory.forEach {
            total += $0.appearCount
        }
        return total
    }
    
    var awayTotalHits: Int {
        var total = 0
        self.awayBattingHistory.forEach {
            total += $0.hitCount
        }
        return total
    }
    
    var awayTotalOut: Int {
        var total = 0
        self.awayBattingHistory.forEach {
            total += $0.outCount
        }
        return total
    }
}

extension GameHistoryViewModel {
    var homeBattingHistory: [BattingHistory] {
        return battingHistory?.homeTeam.battingHistory ?? []
    }
    var homeTotalAppearCount: Int {
        var total = 0
        self.homeBattingHistory.forEach {
            total += $0.appearCount
        }
        return total
    }
    
    var homeTotalHits: Int {
        var total = 0
        self.homeBattingHistory.forEach {
            total += $0.hitCount
        }
        return total
    }
    
    var homeTotalOut: Int {
        var total = 0
        self.homeBattingHistory.forEach {
            total += $0.outCount
        }
        return total
    }
}
