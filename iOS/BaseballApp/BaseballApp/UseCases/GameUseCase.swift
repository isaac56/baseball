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
    
    func pitch(url: URL) -> AnyPublisher<PitchResult, Error> {
        let result = ["pitch_result": "STRIKE"]
        let data = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        return apiRequestManager.fetch(url: url, method: .post, httpBody: data)
    }
}

struct PitchResult: Decodable {
    let error: String?
}
