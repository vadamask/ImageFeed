//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Вадим Шишков on 09.08.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        loginTextField.tap()
        sleep(3)
        loginTextField.typeText("your_login")
        passwordTextField.tap()
        sleep(3)
        passwordTextField.typeText("your_password")
        webView.tap()
        sleep(3)
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cellToSwipe = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cellToSwipe.waitForExistence(timeout: 3))
        cellToSwipe.swipeUp()
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["like disable"].tap()
        sleep(2)
        cellToLike.buttons["like active"].tap()
        sleep(2)
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3, velocity: 1)
        sleep(2)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(2)
        
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        let tabBars = app.tabBars
        let button = tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        
        XCTAssertTrue(app.staticTexts["your_name"].exists)
        XCTAssertTrue(app.staticTexts["username"].exists)
        
        app.buttons["Logout"].tap()
        sleep(2)
        app.alerts["Alert"].scrollViews.otherElements.buttons["Ok"].tap()
        sleep(2)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
