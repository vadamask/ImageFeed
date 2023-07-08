//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 25.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    private var networkService = OAuth2Service()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        imageView.image = UIImage(named: "logo_practicum")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let rootVC = navigationController.viewControllers[0] as? AuthViewController
            else { assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            rootVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let tabBar = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBar
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(with: code)
        }
    }
    
    private func fetchOAuthToken(with code: String) {
        networkService.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.token = token
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
            }
        }
    }
}

