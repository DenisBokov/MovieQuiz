import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private enum movieQuizeFont: String {
        case medium = "YSDisplay-Medium"
        case bold = "YSDisplay-Bold"
    }
    
    // MARK: - IB Outlets
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingFontLabel(for: counterLabel, withFont: movieQuizeFont.medium.rawValue, size: 20)
        settingFontLabel(for: questionTitleLabel, withFont: movieQuizeFont.medium.rawValue, size: 20)
        settingFontLabel(for: textLabel, withFont: movieQuizeFont.bold.rawValue, size: 23)
        
        settingTitleButton(for: yesButton,withFont: movieQuizeFont.medium.rawValue, size: 20)
        settingTitleButton(for: noButton,withFont: movieQuizeFont.medium.rawValue, size: 20)
        
        imageView.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let giveAnswer = false
        
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let giveAnswer = true
        
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        
        return questionStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.text
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            stopClicking(click: false)
            settingFrameImage(for: imageView, with: .ypGreenIOS)
        
            correctAnswers += 1
        } else {
            stopClicking(click: false)
            settingFrameImage(for: imageView, with: .ypRedIOS)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.stopClicking(click: true)
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть еще раз"
            )
            
            show(quiz: viewModel)
            imageView.layer.borderColor = UIColor.clear.cgColor
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func stopClicking(click: Bool) {
        self.yesButton.isEnabled = click
        self.noButton.isEnabled = click
    }
}

extension MovieQuizViewController {
    private func settingFontLabel(for label: UILabel, withFont: String, size: CGFloat) {
        label.font = UIFont(name: withFont, size: size)
    }
    
    private func settingTitleButton(for button: UIButton, withFont: String, size: CGFloat) {
        button.titleLabel?.font = UIFont(name: withFont, size: size)
    }
    
    private func settingFrameImage(for imageView: UIImageView, with color: UIColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
