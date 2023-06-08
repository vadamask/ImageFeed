//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
  
  @IBOutlet private weak var profileImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var userNameLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var logOutButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  private func setupUI() {
    view.backgroundColor = .ypBlack
    
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    profileImageView.image = UIImage(named: "Photo")
    
    logOutButton.setTitle("", for: .normal)
    logOutButton.setImage(UIImage(named: "LogoutButton"), for: .normal)
    logOutButton.tintColor = .ypRed
    
    nameLabel.text = "Екатерина Новикова"
    nameLabel.textColor = .ypWhite
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    
    userNameLabel.text = "@ekaterina_nov"
    userNameLabel.textColor = .ypGray
    userNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    descriptionLabel.text = "Hello, World!"
    descriptionLabel.textColor = .ypWhite
    descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
  }
  
  @IBAction private func logOutButtonPressed() {
    
  }
  
}
