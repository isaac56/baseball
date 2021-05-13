//
//  GameHistoryUseCase.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import Foundation
import Combine

class GameHistoryUseCase {
    let apiRequestManager = APIRequestManager()
    
    func start(url: URL) -> AnyPublisher<BattingHistoryResponse, Error> {
        return apiRequestManager.fetch(url: url, method: .get)
    }
}
