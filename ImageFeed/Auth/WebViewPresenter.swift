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
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    func viewDidLoad() {
        loadRequest()
        observeWebViewProgress()
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func loadRequest() {
        guard var urlComponents = URLComponents(string: AuthConfiguration.shared.unsplashAuthorizeURLString) else {
            assertionFailure("Failed to make urlComponents from \(AuthConfiguration.shared.unsplashAuthorizeURLString)")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.shared.accessKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.shared.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AuthConfiguration.shared.accessScope)
        ]
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            view?.load(request)
        } else {
            assertionFailure("Failed to make URL from \(urlComponents)")
        }
    }
    
    private func observeWebViewProgress() {
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
