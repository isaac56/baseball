//
//  BattingHistory.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/11.
//

import Foundation

struct BattingHistoryResponse: Decodable {
    let data: BattingHistoryData
}

struct BattingHistoryData: Decodable {
    let awayTeam: TeamInfo
    let homeTeam: TeamInfo
    
    enum CodingKeys: String, CodingKey {
        case awayTeam = "away_team"
        case homeTeam = "home_team"
    }
}

struct TeamInfo: Decodable {
    let teamName: String
    let scores: [Int]
    let battingHistory: [BattingHistory]
    
    enum CodingKeys: String, CodingKey {
        case scores
        case teamName = "team_name"
        case battingHistory = "batting_history"
    }
}

struct BattingHistory: Decodable {
    let uniformNumber: Int
    let name: String
    let appearCount: Int
    let hitCount: Int
    let outCount: Int
    let hitRatio: Double
    let isPlaying: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case uniformNumber = "uniform_number"
        case appearCount = "appear_count"
        case hitCount = "hit_count"
        case outCount = "out_count"
        case hitRatio = "hit_ratio"
        case isPlaying = "playing"
    }
}
