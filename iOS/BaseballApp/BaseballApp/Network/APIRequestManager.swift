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
    
    private func createRequest(url: URL, method: HTTPMethod, httpBody: Data?, authorization: String?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
  
    func fetch<T: Decodable>(url: URL, method: HTTPMethod, httpBody: Data? = nil, authorization: String? = nil) -> AnyPublisher<T, Error> {
        let request = createRequest(url: url, method: method, httpBody: httpBody, authorization: authorization)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                switch httpResponse.statusCode {
                case 200: print("success")
                case 401: print("401 - bad request")
                    throw CustomError.badRequest
                default: break
                }
                return element.data
            }
            //.map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

struct Endpoint {
    static let basePath = "/game"
    
    enum Path {
        static let gameList = basePath + "/list"
        static let gameStatus = basePath + "/status"
        static let pitchResult = basePath + "/status/pitch-result"
        static let gameHistory = basePath + "/history"
        static let join = basePath + "/joining"
        static let login = "/user/login/oauth/github"
    }
    
    static func url(path: String, queryItem: [URLQueryItem] = []) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "52.78.19.43"
        components.port = 8080
        components.path = path
        components.queryItems = queryItem
        return components.url
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
