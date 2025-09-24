import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func hideScreeElements(yesOrNo: Bool)
    
    func stopClicking(click: Bool)
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
   
    private enum movieQuizeFont: String {
        case medium = "YSDisplay-Medium"
        case bold = "YSDisplay-Bold"
    }

    // MARK: - IB Outlets
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
     
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter?
    
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
        
        presenter = MovieQuizPresenter(viewController: self)
        
        showLoadingIndicator()
        
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    // MARK: - Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.text
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(titele: result.title, message: result.text, buttonTitle: result.buttonText) { [weak self] in
            guard let self else { return }
            self.presenter?.restartGame()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
        
        alertPresenter.showAlert(viewController: self, model: model)
    }
    
    func stopClicking(click: Bool) {
        self.yesButton.isEnabled = click
        self.noButton.isEnabled = click
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating() 
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        imageView.image = UIImage(named: "The Godfather")
        
        alertPresenter.showAlertForError(viewController: self, message: message, restartGame: { [weak self] in
            guard let self else { return }
            self.showLoadingIndicator()
            self.presenter?.restartGame()
        })
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func hideScreeElements(yesOrNo: Bool) {
        questionTitleLabel.isHidden = yesOrNo
        counterLabel.isHidden = yesOrNo
        textLabel.isHidden = yesOrNo
    }
}

extension MovieQuizViewController {
    private func settingFontLabel(for label: UILabel, withFont: String, size: CGFloat) {
        label.font = UIFont(name: withFont, size: size)
    }
    
    private func settingTitleButton(for button: UIButton, withFont: String, size: CGFloat) {
        button.titleLabel?.font = UIFont(name: withFont, size: size)
    }
}
