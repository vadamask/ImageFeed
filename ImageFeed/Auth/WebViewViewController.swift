//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var progressView: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        setupViews()
        makeRequest()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func setupViews() {
        progressView.progressTintColor = .ypBlack
        progressView.progress = 0.0
        progressView.isHidden = true
        
        webView.backgroundColor = .ypWhite
        webView.isOpaque = false
        
        
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "nav_back_button"), for: .normal)
    }
    
    private func makeRequest() {
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else {
            assertionFailure("Failed to make urlComponents from \(UnsplashAuthorizeURLString)")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            assertionFailure("Failed to make URL from \(urlComponents)")
            return
        }
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

