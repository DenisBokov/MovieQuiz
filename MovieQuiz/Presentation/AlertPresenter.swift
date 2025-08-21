//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 21.08.2025.
//

import UIKit

class AlertPresenter {
    func showAlert(viewController: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.titele, message: model.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonTitle, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
