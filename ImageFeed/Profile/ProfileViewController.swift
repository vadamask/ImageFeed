//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
  
  private var profileImageView: UIImageView!
  private var nameLabel: UILabel!
  private var userNameLabel: UILabel!
  private var descriptionLabel: UILabel!
  private var logOutButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setConstraints()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  private func setupUI() {
    view.backgroundColor = .ypBlack
    
    profileImageView = UIImageView()
    profileImageView.image = UIImage(named: "Photo")
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(profileImageView)
    
    nameLabel = UILabel()
    nameLabel.text = "Екатерина Новикова"
    nameLabel.textColor = .ypWhite
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nameLabel)
    
    userNameLabel = UILabel()
    userNameLabel.text = "@ekaterina_nov"
    userNameLabel.textColor = .ypGray
    userNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(userNameLabel)
    
    descriptionLabel = UILabel()
    descriptionLabel.text = "Hello, World!"
    descriptionLabel.textColor = .ypWhite
    descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(descriptionLabel)
    
    logOutButton = UIButton.systemButton(with: UIImage(named: "button_logout")!, target: self, action: #selector(logOutButtonPressed))
    logOutButton.tintColor = .ypRed
    logOutButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(logOutButton)
  }
  
  private func setConstraints() {
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
  
  @objc private func logOutButtonPressed() {
    
  }
  
}
