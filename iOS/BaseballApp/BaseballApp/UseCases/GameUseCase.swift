//
//  GameUseCase.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/05.
//

import Foundation
import Combine

class GameUseCase {
    let apiRequestManager = APIRequestManager()
    
    func start(url: URL) -> AnyPublisher<GameResponse, Error> {
        return apiRequestManager.fetch(url: url, method: .get)
    }
    
    func pitch(url: URL) {
        let result = ["pitch_result": "STRIKE"]
        let data = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        apiRequestManager.fetch(url: url, method: .post, httpBody: data)
    }
}
