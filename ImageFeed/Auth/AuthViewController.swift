//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import UIKit

class AuthViewController: UIViewController {
  
  @IBOutlet private var logoImageView: UIImageView!
  @IBOutlet private var button: UIButton!
  private let toWebView = "ShowWebView"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .ypBlack
    logoImageView.image = UIImage(named: "logo_of_unsplash")
    
    button.backgroundColor = .ypWhite
    button.layer.cornerRadius = 16
    
    button.setTitle("Войти", for: .normal)
    button.setTitleColor(.ypBlack, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toWebView {
      let wvvc = segue.destination as? WebViewViewController
      wvvc?.delegate = self
    }
  }
  
  @IBAction private func buttonTapped() {
    
  }
  
}

extension AuthViewController: WebViewViewControllerDelegate {
  
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    vc.dismiss(animated: true)
  }
  
  
}
