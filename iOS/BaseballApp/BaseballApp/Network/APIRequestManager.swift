//
//  APIRequestManager.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation
import Combine

class APIRequestManager {
    
    private let decoder = JSONDecoder()
    
    private func createRequest(url: URL, method: HTTPMethod, httpBody: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
  
    func fetch<T: Decodable>(url: URL, method: HTTPMethod, httpBody: Data? = nil) -> AnyPublisher<T, Error> {
        let request = createRequest(url: url, method: method)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetch(url: URL, method: HTTPMethod, httpBody: Data? = nil) {
        var request = createRequest(url: url, method: method)
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
        }.resume()
    }
}

struct Endpoint {
    enum Path {
        static let gameList = "/game/list"
        static let gameStatus = "/game/status"
        static let pitchResult = "/game/status/pitch-result"
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
