//
//  Room.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/04.
//

import Foundation

struct RoomResponse: Decodable {
    let data: [Room]?
    let error: String?
}

struct Room: Decodable {
    let id: Int
    let awayTeam: String?
    let homeTeam: String?
    let awayUserEmail: String?
    let homeUserEmail: String?
}
