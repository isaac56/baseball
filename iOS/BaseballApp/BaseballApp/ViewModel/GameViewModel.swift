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
        } receiveValue: { (response) in
            self.game = response
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
    
    func convert(inning: String, halves: String) -> String {
        var convertedHalves = ""
        switch halves {
        case "TOP":
            convertedHalves = "초"
        case "BOTTOM":
            convertedHalves = "말"
        default:
            convertedHalves = ""
        }
        return "\(inning)회\(convertedHalves)"
    }
    
    func convert(myRole: String) -> String {
        var convertedRole = ""
        switch myRole {
        case "ATTACK":
            convertedRole = "공격"
        case "DEFENSE":
            convertedRole = "수비"
        default:
            convertedRole = ""
        }
        return convertedRole
    }
}
