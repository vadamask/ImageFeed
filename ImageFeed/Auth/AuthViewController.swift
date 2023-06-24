//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import UIKit

final class AuthViewController: UIViewController {
  
  @IBOutlet private var logoImageView: UIImageView!
  @IBOutlet private var button: UIButton!
  private var networkService: OAuth2Service!
  private var tokenStorage: OAuth2TokenStorage!
  private let segueToWebView = "ShowWebView"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    networkService = OAuth2Service()
    tokenStorage = OAuth2TokenStorage()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueToWebView {
      let wvvc = segue.destination as? WebViewViewController
      wvvc?.delegate = self
    }
  }
  
  private func setupViews() {
    view.backgroundColor = .ypBlack
    logoImageView.image = UIImage(named: "logo_of_unsplash")
    
    button.backgroundColor = .ypWhite
    button.layer.cornerRadius = 16
    
    button.setTitle("Войти", for: .normal)
    button.setTitleColor(.ypBlack, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
  }
  
  @IBAction private func buttonTapped() {
    
  }
  
}

extension AuthViewController: WebViewViewControllerDelegate {
  
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    networkService.fetchAuthToken(code: code) { [weak self] result in
      switch result {
      case .success(let data):
        let decoder = JSONDecoder()
        do {
          let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
          self?.tokenStorage.token = responseBody.accessToken
        } catch {
          print("Decode error - \(error)")
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    vc.dismiss(animated: true)
  }
  
  
}
