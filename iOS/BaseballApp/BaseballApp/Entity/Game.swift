//
//  Game.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/04.
//

import Foundation

struct GameResponse: Decodable {
    let data: Game
}

struct Game: Decodable {
    let strike: Int
    let ball: Int
    let out: Int
    let awayTeam: Team
    let homeTeam: Team
    let inning: String
    let halves: String
    let pitcher: Player
    let pitcherStatus: String
    let batter: Player
    let batterStatus: String
    let base1: Player?
    let base2: Player?
    let base3: Player?
    let pitchHistories: [Record]
    let myRole: String
}

struct Player: Decodable {
    let teamId: Int
    let uniformNumber: Int
    let name: String
}

struct Record: Decodable {
    let pitcher: Player
    let batter: Player
    let result: String
    let strikeCount: Int
    let ballCount: Int
}

struct Team: Decodable {
    let name: String
    let score: Int
    let role: String
}

struct Scoreboard: Decodable {
    let home: Score
    let away: Score
    let inning: String
}

struct Score: Decodable {
    let teamName: String
    let total: Int
    let scores: [Int]
    let battingStats: [HitterInformation]
}

struct HitterInformation: Decodable {
    let id: Int
    let name: String
    let plateAppearance: Int
    let hits: Int
    let out: Int
    let average: Float
    let isPlaying: Bool
}
