//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 05.08.2023.
//

import Foundation
import WebKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didTapLogoutButton()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let alertPresenter = AlertPresenter()
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        fetchProfile()
        alertPresenter.delegate = self
    }
    
    func viewWillAppear() {
        addObserverForImageURL()
    }
    
    func viewWillDisappear() {
        removeObserverForImageURL()
    }
    
    func didTapLogoutButton() {
        let model = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            agreeButtonTitle: "Да",
            disagreeButtonTitle: "Нет"
        )
        if let view = view as? ProfileViewController {
            alertPresenter.showAlert(with: model, on: view)
        }
    }
    
    private func fetchProfile() {
        profileService.fetchProfile() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                convertResultToViewModel()
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatar(url)
    }
    
    private func addObserverForImageURL() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar(notification:)),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private func removeObserverForImageURL() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private func convertResultToViewModel() {
        guard let profile = profileService.profile else { return }
        let viewModel = ProfileViewModel(
            name: "\(profile.firstName) \(profile.lastName ?? "")",
            userName: "@\(profile.username)",
            description: profile.bio ?? ""
        )
        view?.updateProfileDetails(with: viewModel)
    }
    
    private func cleanAndSwitchToSplashVC() {
        WebViewPresenter.cleanCookies()
        OAuth2TokenStorage.shared.removeToken()
        let window = UIApplication.shared.windows.first
        let splashVC = SplashViewController()
        window?.rootViewController = splashVC
    }
}

// MARK: - AlertPresenterDelegate

extension ProfileViewPresenter: AlertPresenterDelegate {
    func agreeAction() {
        cleanAndSwitchToSplashVC()
    }
    func disagreeAction() {
        view?.dismissAlert()
    }
}

