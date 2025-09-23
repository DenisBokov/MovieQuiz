//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 22.09.2025.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
    
    private var currentQuestionIndex: Int = 0
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        
        return questionStepViewModel
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideScreeElements(yesOrNo: false)
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: viewController?.showMessageInAlert() ?? "",
                buttonText: "Сыграть еще раз"
            )
            
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            
            questionFactory?.requestNextQuestion()
            viewController?.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let giveAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
}
