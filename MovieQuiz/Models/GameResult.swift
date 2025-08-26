//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 24.08.2025.
//

import Foundation

struct GameResult {
    // Кол - во правильных ответов
    let correct: Int
    // Кол - во вопросов квиза
    let total: Int
    // Дату завершения раунда
    let date: Date
    
    func compareResults(gameRecord: GameResult) -> Bool {
        correct > gameRecord.correct
    }
}
