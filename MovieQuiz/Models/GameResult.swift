//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 24.08.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareResults(gameRecord: GameResult) -> Bool {
        correct > gameRecord.correct
    }
}
