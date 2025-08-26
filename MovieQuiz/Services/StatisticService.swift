//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 24.08.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    // Кол-во игр
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date: Date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if totalQuestionsAsked > 0 {
            let resalt = Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
            return resalt
        } else {
            return 0
        }
    }
    
    private let storage: UserDefaults = .standard
    
    // Правильные ответы
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    // Общее кол-во заданных вопросов
    private var totalQuestionsAsked: Int {
        gamesCount * 10
    }
    
    // Общее кол-во правильных ответов за все игры
    private var totalCorrectAnswers: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalCorrectAnswers += count
        correctAnswers += count
        gamesCount += 1
        
        let bestGameReult = GameResult(correct: correctAnswers, total: totalQuestionsAsked, date: Date())
        if bestGameReult.compareResults(gameRecord: bestGame) {
            bestGame = bestGameReult
        }
    }
    
    private enum Keys: String {
        case correctAnswers = "correctAnswers"
        case gamesCount = "gameCount"         // Для счётчика сыгранных игр
        case bestGameCorrect = "bestCorrectGame"    // Для количества правильных ответов в лучшей игре
        case bestGameTotal = "bestTotalGame"       // Для общего количества вопросов в лучшей игре
        case bestGameDate = "bestDateGame"        // Для даты лучшей игры
        case totalCorrectAnswers = "totalCorrectAnswers"  // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked = "totalQuestionsAsked" // Для общего количества вопросов, заданных за все игры
    }
}
