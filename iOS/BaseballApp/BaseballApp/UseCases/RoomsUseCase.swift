//
//  RoomsUseCase.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation
import Combine

class RoomsUseCase {
    let apiRequestManager = APIRequestManager()
    let authorization = UserDefaults.standard.string(forKey: "jwt")
    
    func start(url: URL) -> AnyPublisher<RoomResponse, Error> {
        return apiRequestManager.fetch(url: url, method: .get)
    }
    
    func join(url: URL, gameId: Int, venue: Venue) -> AnyPublisher<RoomResponse, Error> {
        let data: [String: Any] = ["game_id": gameId, "my_venue": venue.rawValue]
        let json = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        return apiRequestManager.fetch(url: url, method: .post, httpBody: json, authorization: authorization)
    }
}

enum Venue: String {
    case home = "HOME"
    case away = "AWAY"
}
