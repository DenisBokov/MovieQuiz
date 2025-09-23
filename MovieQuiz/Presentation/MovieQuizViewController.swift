import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
   
    private enum movieQuizeFont: String {
        case medium = "YSDisplay-Medium"
        case bold = "YSDisplay-Bold"
    }

    // MARK: - IB Outlets
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
     
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter = AlertPresenter()
    var statisticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideScreeElements(yesOrNo: true)
        
        settingFontLabel(for: counterLabel, withFont: movieQuizeFont.medium.rawValue, size: 20)
        settingFontLabel(for: questionTitleLabel, withFont: movieQuizeFont.medium.rawValue, size: 20)
        settingFontLabel(for: textLabel, withFont: movieQuizeFont.bold.rawValue, size: 23)
        
        settingTitleButton(for: yesButton,withFont: movieQuizeFont.medium.rawValue, size: 20)
        settingTitleButton(for: noButton,withFont: movieQuizeFont.medium.rawValue, size: 20)
        
        imageView.layer.cornerRadius = 20
        
        presenter.viewController = self
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory.loadData()
        
        questionFactory.requestNextQuestion()
        
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        imageView.image = UIImage(named: "The Godfather")
        hideScreeElements(yesOrNo: false)
        showNetworkError(message: "Невозможно загрузить данные")
    }
    
    // MARK: - Private Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.text
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            stopClicking(click: false)
            settingFrameImage(for: imageView, with: .ypGreenIOS)
        
            correctAnswers += 1
        } else {
            stopClicking(click: false)
            settingFrameImage(for: imageView, with: .ypRedIOS)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            self.stopClicking(click: true)
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(titele: result.title, message: result.text, buttonTitle: result.buttonText) { [weak self] in
            self?.presenter.resetQuestionIndex()
            self?.correctAnswers = 0
            self?.imageView.layer.borderColor = UIColor.clear.cgColor
            self?.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.showAlert(viewController: self, model: model)
    }
    
    private func stopClicking(click: Bool) {
        self.yesButton.isEnabled = click
        self.noButton.isEnabled = click
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating() 
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
    
        alertPresenter.showAlertForError(viewController: self, message: message)
    }
}

extension MovieQuizViewController {
    func settingFontLabel(for label: UILabel, withFont: String, size: CGFloat) {
        label.font = UIFont(name: withFont, size: size)
    }
    
    func settingTitleButton(for button: UIButton, withFont: String, size: CGFloat) {
        button.titleLabel?.font = UIFont(name: withFont, size: size)
    }
    
    func settingFrameImage(for imageView: UIImageView, with color: UIColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func showMessageInAlert() -> String {
        guard let statisticService = statisticService else { return ""}
        
        let yourResultMessage: String = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)"
        let gamesCountMessage: String = "Коллличество сыгранных квизов: \(statisticService.gamesCount)"
        let recordMessage: String = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
        let totalAccuracyMessage: String = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage: String = [yourResultMessage,
                                     gamesCountMessage,
                                     recordMessage,
                                     totalAccuracyMessage].joined(separator: "\n")
        
        return resultMessage
    }
    
    func hideScreeElements(yesOrNo: Bool) {
        questionTitleLabel.isHidden = yesOrNo
        counterLabel.isHidden = yesOrNo
        textLabel.isHidden = yesOrNo
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
