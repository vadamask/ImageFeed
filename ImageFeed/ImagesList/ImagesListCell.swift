//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
  
  @IBOutlet var cellImageView: UIImageView!
  @IBOutlet var likeButton: UIButton!
  @IBOutlet var dateLabel: UILabel!
  
  static let reuseIdentifier = "ImagesListCell"
}
