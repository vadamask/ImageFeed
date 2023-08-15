//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 04.08.2023.
//

import Foundation
import WebKit

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func code(from url: URL) -> String?
    func observeProgressFor(_ webView: WKWebView)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    private var authHelper: AuthHelperProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        if let request = authHelper.authRequest() {
            view?.load(request)
        } else {
            assertionFailure("Failed with making request")
        }
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func observeProgressFor(_ webView: WKWebView) {
        estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
            guard let self = self else { return }
            didUpdateProgressValue(webView.estimatedProgress)
        }
    }
    
    private func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
}
