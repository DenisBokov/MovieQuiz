//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Denis Bokov on 21.08.2025.
//

import Foundation

struct AlertModel {
    let titele: String
    let message: String
    let buttonTitle: String
    var completion: () -> Void
}
