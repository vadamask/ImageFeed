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
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        fetchProfile()
    }
    
    func viewWillAppear() {
        addObserverForImageURL()
    }
    
    func viewWillDisappear() {
        removeObserverForImageURL()
    }
    
    func didTapLogoutButton() {
        let alertController = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.cleanAndSwitchToSplashVC()
        }
        yesAction.accessibilityIdentifier = "Ok"
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertController.view.accessibilityIdentifier = "Alert"
        view?.showAlertController(alertController)
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
        cleanCookies()
        OAuth2TokenStorage.shared.removeToken()
        let window = UIApplication.shared.windows.first
        let splashVC = SplashViewController()
        window?.rootViewController = splashVC
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
