//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
  
  @IBOutlet private var webView: WKWebView!
  @IBOutlet private var backButton: UIButton!
  var delegate: WebViewViewControllerDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.backgroundColor = .ypWhite
    webView.isOpaque = false
    webView.navigationDelegate = self
    
    backButton.setTitle("", for: .normal)
    backButton.setImage(UIImage(named: "nav_back_button"), for: .normal)
    
    var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: AccessKey),
      URLQueryItem(name: "redirect_uri", value: RedirectURI),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: AccessScope)
    ]
    let url = urlComponents.url!
    
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  @IBAction private func didTapBackButton(_ sender: Any?) {
    
  }
  
}


extension WebViewViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    if let code = code(from: navigationAction) {
      //TODO: process code
      
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
