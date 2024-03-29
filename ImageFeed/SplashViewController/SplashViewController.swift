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
    private let tokenStorage = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        setupConstraints()
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = tokenStorage.bearerToken {
            switchToTabBarController()
        } else {
            if !networkService.isLoading {
                switchToAuthViewController()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = tabBarController
    }
    
    private func showAlert() {
        let model = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему\nпроверьте сетевое подключение",
            agreeButtonTitle: "Ок"
        )
        alertPresenter.showAlert(with: model, on: self)
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        networkService.isLoading = true
        dismiss(animated: true) {
            self.fetchOAuthToken(with: code)
        }
    }
    
    private func fetchOAuthToken(with code: String) {
        UIBlockingProgressHUD.show()
        networkService.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                tokenStorage.bearerToken = token
                UIBlockingProgressHUD.dismiss()
                switchToTabBarController()
            case .failure(let error):
                print(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                showAlert()
            }
        }
    }
}

// MARK: - AlertPresenterDelegate

extension SplashViewController: AlertPresenterDelegate {
    func agreeAction() {
        WebViewPresenter.cleanCookies()
        switchToAuthViewController()
    }
}

