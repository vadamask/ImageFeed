//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.06.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func setAvatar(_ url: URL)
    func updateProfileDetails(with model: ProfileViewModel)
    func dismissAlert()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    private var labelsGradientViews: Set<GradientView> = []
    private var profileImageGradientView: GradientView!
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "button_logout")!,
            target: self,
            action: #selector(logoutButtonPressed)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "Logout"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        addGradientViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setAvatar(_ url: URL) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor)]
        ) { [weak self] _ in
            guard let self = self else { return }
            self.profileImageGradientView.removeAllAnimations()
            self.profileImageGradientView.removeFromSuperview()
        }
    }
    
    func updateProfileDetails(with model: ProfileViewModel) {
        nameLabel.text = model.name
        userNameLabel.text = model.userName
        descriptionLabel.text = model.description
        removeLabelAnimations()
    }
    
    func dismissAlert() {
        dismiss(animated: true)
    }
    
    @objc private func logoutButtonPressed() {
        presenter?.didTapLogoutButton()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(userNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
            
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            userNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func addGradientViews() {
        profileImageGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 70, height: 70), cornerRadius: 35)
        let nameLabelGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 200, height: 28), cornerRadius: 14)
        let userNameLabelGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 100, height: 18), cornerRadius: 9)
        let descriptionLabelGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 100, height: 18), cornerRadius: 9)
        
        profileImageView.addSubview(profileImageGradientView)
        nameLabel.addSubview(nameLabelGradientView)
        userNameLabel.addSubview(userNameLabelGradientView)
        descriptionLabel.addSubview(descriptionLabelGradientView)
        
        labelsGradientViews.insert(nameLabelGradientView)
        labelsGradientViews.insert(userNameLabelGradientView)
        labelsGradientViews.insert(descriptionLabelGradientView)
        
        [profileImageGradientView, nameLabelGradientView, userNameLabelGradientView, descriptionLabelGradientView].forEach { view in
            view?.animateGradientLayerLocations()
        }
    }
    
    func removeLabelAnimations() {
        labelsGradientViews.forEach { view in
            view.removeAllAnimations()
            view.removeFromSuperview()
        }
    }
}
