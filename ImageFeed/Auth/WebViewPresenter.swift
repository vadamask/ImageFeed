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
    private let authHelper: AuthHelperProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?
    private let alertPresenter = AlertPresenter()
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        alertPresenter.delegate = self
        if let request = authHelper.authRequest() {
            view?.load(request)
        } else {
            showAlert()
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
    
    static func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func showAlert() {
        let model = AlertModel(
            title: "Что-то пошло не так",
            message: "Проверьте подключение к интернету и попробуйте еще раз",
            agreeButtonTitle: "Ок"
        )
        if let view = view as? WebViewViewController {
            alertPresenter.showAlert(with: model, on: view)
        }
    }
    
    private func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
}

// MARK: - AlertPresenterDelegate

extension WebViewPresenter: AlertPresenterDelegate {
    func agreeAction() {
        view?.dismissAlert()
    }
}
