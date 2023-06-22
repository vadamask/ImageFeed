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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.backgroundColor = .ypWhite
    webView.isOpaque = false
    
    backButton.setTitle("", for: .normal)
    backButton.setImage(UIImage(named: "nav_back_button"), for: .normal)
  }
  
  @IBAction private func didTapBackButton(_ sender: Any?) {
    
  }
  
}
