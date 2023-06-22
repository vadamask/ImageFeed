//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import UIKit

class AuthViewController: UIViewController {
  
  @IBOutlet private var logoImageView: UIImageView!
  @IBOutlet private var button: UIButton!
  private let segueIdentifier = "ShowWebView"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .ypBlack
    logoImageView.image = UIImage(named: "logo_of_unsplash")
    
    button.backgroundColor = .ypWhite
    button.layer.cornerRadius = 16
    
    button.setTitle("Войти", for: .normal)
    button.setTitleColor(.ypBlack, for: .normal)
   // button.setTitleColor(.ypBlack, for: .highlighted)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    
    
  }
  
  @IBAction private func buttonTapped() {
    
  }
 
  
}
