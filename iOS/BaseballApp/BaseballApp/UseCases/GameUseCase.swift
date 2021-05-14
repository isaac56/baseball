//
//  GameUseCase.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/05.
//

import Foundation
import Combine

class GameUseCase {
    enum PitchResult: CaseIterable, CustomStringConvertible {
        case strike
        case ball
        case hit
        
        var description: String {
            switch self {
            case .strike:
                return "STRIKE"
            case .ball:
                return "BALL"
            case .hit:
                return "HIT"
            }
        }
    }
    
    let apiRequestManager = APIRequestManager()
    let authorization = UserDefaults.standard.string(forKey: "jwt")
    
    func start(url: URL) -> AnyPublisher<GameResponse, Error> {
        return apiRequestManager.fetch(url: url, method: .get, authorization: authorization)
    }
    
    func pitch(url: URL) -> AnyPublisher<PitchResponse, Error> {
        let randomResult = PitchResult.allCases.randomElement()?.description
        let result = ["pitch_result": randomResult]
        let data = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        return apiRequestManager.fetch(url: url, method: .post, httpBody: data, authorization: authorization)
    }
}

struct PitchResponse: Decodable {
    let error: String?
}
