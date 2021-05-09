//
//  APIRequestManager.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation
import Combine

class APIRequestManager {
    private var cancelBag = Set<AnyCancellable>()
    
    private func createRequest(url: URL, method: HTTPMethod, httpBody: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        return request
    }
    
    func fetchRooms(url: URL, method: HTTPMethod, httpBody: Data? = nil) {
        let request = createRequest(url: url, method: method)
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: RoomResponse.self, decoder: JSONDecoder())
            .replaceError(with: RoomResponse(data: []))
            .assign(to: \.rooms, on: RoomsViewModel())
            .store(in: &self.cancelBag)
    }
    
    func fetchGame(url: URL, method: HTTPMethod, httpBody: Data? = nil) {
        let request = createRequest(url: url, method: method)
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Game?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .assign(to: \.game, on: GameViewModel())
            .store(in: &self.cancelBag)
    }
}

struct Endpoint {
    enum Path {
        static let gameList = "/game/list"
    }

    static func url(path: String) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "52.78.19.43"
        components.port = 8080
        components.path = path
        return components.url
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
