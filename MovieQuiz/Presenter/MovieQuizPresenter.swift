//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 22.09.2025.
//

final class MovieQuizPresenter {
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        
        return questionStepViewModel
    }
}
