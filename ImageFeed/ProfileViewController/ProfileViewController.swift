//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.06.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "button_logout")!,
            target: self,
            action: #selector(logOutButtonPressed)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    deinit {
        removeObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .ypBlack
        addObserver()
        setupConstraints()
        updateProfileDetails()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func updateProfileDetails() {
        
        guard let profile = profileService.profile else { return }
        nameLabel.text = "\(profile.firstName) \(profile.lastName ?? "")"
        userNameLabel.text = "@\(profile.username)"
        descriptionLabel.text = profile.bio
        
        if let imageURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: imageURL) {
               setAvatar(url)
        }
    }
    
    private func setAvatar(_ url: URL) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 25)
        
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor), .transition(.fade(1))]
        )
    }
    
    private func setupConstraints() {
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(userNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar(notification:)),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    @objc
    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        
        setAvatar(url)
    }
    
    @objc
    private func logOutButtonPressed() {}
    
}
