//
//  ViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit

class ImagesListViewController: UIViewController {

  
  @IBOutlet private var tableView: UITableView!
  
  private let photosName = Array(0..<20).map { "\($0)" }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupView()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = UIColor.ypBlack
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
  }
  
  private func setupView() {
    view.backgroundColor = UIColor.ypBlack
  }
  
  private lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .long
      formatter.timeStyle = .none
      return formatter
  }()
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
}

extension ImagesListViewController {
  
  private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    
    // Setup cell
    cell.backgroundColor = .clear
    
    // Setup image view
    let imageName = photosName[indexPath.row]
    if let image = UIImage(named: imageName) {
      cell.cellImageView.image = image
    } else {
      preconditionFailure("Image Not Found")
    }
    cell.cellImageView.contentMode = .scaleAspectFill
    cell.cellImageView.layer.masksToBounds = true
    cell.cellImageView.layer.cornerRadius = 16
    
    // Setup label
    cell.dateLabel.textColor = .ypWhite
    cell.dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
    cell.dateLabel.text = dateFormatter.string(from: Date())
    cell.dateLabel.layer.shadowColor = UIColor.black.cgColor
    cell.dateLabel.layer.shadowOpacity = 1
    cell.dateLabel.layer.shadowRadius = 7
    cell.dateLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
    
    // Setup button
    cell.likeButton.tintColor = .ypRed
    cell.likeButton.setTitle("", for: .normal)
    if indexPath.row % 2 == 0 {
      cell.likeButton.setImage(UIImage(named: "ActiveLike"), for: .normal)
    } else {
      cell.likeButton.setImage(UIImage(named: "NoActiveLike"), for: .normal)
    }
  }
}
