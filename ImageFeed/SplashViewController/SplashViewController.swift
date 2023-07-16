//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 25.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo_practicum")
        return imageView
    }()
    
    private let networkService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.bearerToken {
            fetchProfile(with: token)
        } else {
            if !networkService.isLoading {
                switchToAuthViewController()
            }
        }
    }
    
    private func switchToAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
    
    private func switchToTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = .ypBlack
        tabBarController.tabBar.tintColor = .ypWhite
        
        let window = UIApplication.shared.windows.first!
        window.rootViewController = tabBarController
    }
    
    private func showAlert(with error: Error) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему\n" + error.localizedDescription,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ок", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            switchToAuthViewController()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        networkService.isLoading = true
        dismiss(animated: true) {
            self.fetchOAuthToken(with: code)
        }
    }
    
    private func fetchOAuthToken(with code: String) {
        networkService.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                tokenStorage.bearerToken = token
                fetchProfile(with: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                showAlert(with: error)
            }
        }
    }
    
    private func fetchProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { [weak self] _ in
                    guard let self = self else { return }
                    self.switchToTabBarController()
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                showAlert(with: error)
            }
        }
    }
}

