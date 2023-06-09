//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 09.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet private weak var backButton: UIButton!
  
  var image: UIImage! {
    didSet {
      guard isViewLoaded else { return }
      imageView.image = image
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  private func setupUI() {
    view.backgroundColor = .ypBlack
    
    imageView.backgroundColor = .ypBlack
    imageView.contentMode = .scaleAspectFill
    imageView.image = image
    
    backButton.setImage(UIImage(named: "button_backward"), for: .normal)
    backButton.setTitle("", for: .normal)
  }
  
  @IBAction private func didTapBackButton() {
    dismiss(animated: true)
  }
}
