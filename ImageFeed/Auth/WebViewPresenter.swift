//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 04.08.2023.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func code(from url: URL) -> String?
    func observeWebViewProgress()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var authHelper: AuthHelperProtocol
    weak var view: WebViewViewControllerProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func observeWebViewProgress() {
        estimatedProgressObservation = view?.webView.observe(\.estimatedProgress) { [weak self] _, _ in
            guard let self = self,
                  let view = view else { return }
            didUpdateProgressValue(view.webView.estimatedProgress)
        }
    }
    
    private func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
}
