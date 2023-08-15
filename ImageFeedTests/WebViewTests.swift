//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Вадим Шишков on 05.08.2023.
//

import XCTest
import WebKit
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 0.6
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 1
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.authURL()!
        let urlString = url.absoluteString
        
        // then
        XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
    
        // when
        let code = authHelper.code(from: url)
        
        // then
        XCTAssertEqual(code, "test code")
    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    func code(from url: URL) -> String? {
        return nil
    }
    func observeProgressFor(_ webView: WKWebView) {}
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled = false
    var presenter: WebViewPresenterProtocol?
    
    func load(_ request: URLRequest) {
        loadRequestCalled = true
    }
    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}
