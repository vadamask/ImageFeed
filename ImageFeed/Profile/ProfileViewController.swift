//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
  
  private var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Photo")
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = imageView.frame.width / 2
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Екатерина Новикова"
    label.textColor = .ypWhite
    label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var userNameLabel: UILabel = {
    let label = UILabel()
    label.text = "@ekaterina_nov"
    label.textColor = .ypGray
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Hello, World!"
    label.textColor = .ypWhite
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var logOutButton: UIButton = {
    let button = UIButton.systemButton(
      with: UIImage(named: "button_logout")!,
      target: self,
      action: #selector(logOutButtonPressed)
    )
    button.tintColor = .ypRed
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .ypBlack
    setupConstraints()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
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
  
  @objc private func logOutButtonPressed() {
    
  }
  
}
