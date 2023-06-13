//
//  ViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {

  @IBOutlet private var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.backgroundColor = UIColor.ypBlack
      tableView.separatorStyle = .none
      tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
  }
  
  private let photosName = Array(0..<20).map { "\($0)" }
  private let showSingleImageSegueIdentifer = "ShowSingleImage"
  
  private lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .long
      formatter.timeStyle = .none
      return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.ypBlack
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showSingleImageSegueIdentifer {
      let viewController = segue.destination as! SingleImageViewController
      let indexPath = sender as! IndexPath
      let image = UIImage(named: photosName[indexPath.row])
      viewController.image = image
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

extension ImagesListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photosName.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    guard let imageListCell = cell as? ImagesListCell else {
      preconditionFailure("Casting error")
    }
    configCell(for: imageListCell, with: indexPath)
    return imageListCell
  }
}

extension ImagesListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    guard let image = UIImage(named: "\(indexPath.row)") else {
      preconditionFailure("Image Not Found")
    }
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = image.size.width
    let scale = imageViewWidth / imageWidth
    let imageHeight = image.size.height * scale
    let imageViewHeight = imageHeight + imageInsets.top + imageInsets.bottom
    return imageViewHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: showSingleImageSegueIdentifer, sender: indexPath)
  }
}

extension ImagesListViewController {
  
  private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    
    cell.backgroundColor = .ypBlack
    cell.mainView.backgroundColor = .ypBlack
    cell.mainView.clipsToBounds = true
    cell.mainView.layer.cornerRadius = 16
    
    let imageName = photosName[indexPath.row]
    if let image = UIImage(named: imageName) {
      cell.cellImageView.image = image
    } else {
      preconditionFailure("Image Not Found")
    }
    cell.cellImageView.contentMode = .scaleAspectFill
  
    cell.dateLabel.textColor = .ypWhite
    cell.dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
    cell.dateLabel.text = dateFormatter.string(from: Date())
    
    cell.likeButton.tintColor = .ypRed
    cell.likeButton.setTitle("", for: .normal)
    if indexPath.row % 2 != 0 {
      cell.likeButton.setImage(UIImage(named: "like_active"), for: .normal)
    } else {
      cell.likeButton.setImage(UIImage(named: "like_disable"), for: .normal)
    }

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
      UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor
    ]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(
      a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0)
    )
    
    gradientLayer.frame = cell.gradientView.bounds.insetBy(
      dx: -0.5 * cell.gradientView.bounds.size.width,
      dy: -0.5 * cell.gradientView.bounds.size.height
    )
    cell.gradientView.backgroundColor = .clear
    cell.gradientView.layer.addSublayer(gradientLayer)
  }
}
