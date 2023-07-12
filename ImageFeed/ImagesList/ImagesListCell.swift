//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlack
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        button.setTitle("", for: .normal)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0)
        )
        gradientLayer.frame = view.bounds.insetBy(
            dx: -0.5 * view.bounds.size.width,
            dy: -0.5 * view.bounds.size.height
        )
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mainView)
        mainView.addSubview(cellImageView)
        mainView.addSubview(likeButton)
        mainView.addSubview(gradientView)
        mainView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            cellImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            cellImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            cellImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            cellImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            
            likeButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            likeButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            gradientView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            gradientView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            gradientView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8),
            dateLabel.widthAnchor.constraint(equalToConstant: 152),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with indexPath: IndexPath) {
        
        self.backgroundColor = .ypBlack
        dateLabel.text = dateFormatter.string(from: Date())
        
        if let image = UIImage(named: "\(indexPath.row)") {
            cellImageView.image = image
        } else {
            preconditionFailure("Image Not Found")
        }

        if indexPath.row % 2 != 0 {
            likeButton.setImage(UIImage(named: "like_active"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_disable"), for: .normal)
        }
    }
}
