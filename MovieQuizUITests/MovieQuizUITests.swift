//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Denis Bokov on 16.09.2025.
//

import XCTest
@testable import MovieQuiz

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
                
        app.terminate()
        app = nil
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        
        sleep(3)
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)
        
        XCTAssertFalse(firstPosterData == secondPosterData) // проверяем, что постеры разные
//        XCTAssertNotEqual(firstPosterData, secondPosterData) // второй вариант проверки
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["No"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testFinishGame() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }

        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
