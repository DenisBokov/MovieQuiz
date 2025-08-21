//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 21.08.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
