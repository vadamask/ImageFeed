//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func likeButtonDidTapped(at indexPath: IndexPath)
}

final class ImagesListCell: UITableViewCell {
 
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private var indexPath: IndexPath?
    private var gradientView: GradientView?
    private var state: CellImageState = .loading
    
    private enum CellImageState {
        case loading
        case error
        case finished(UIImage)
    }
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite50
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
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        removeGradientView()
    }
    
    func configure(with model: ImagesListCellModel, at indexPath: IndexPath) {
        self.indexPath = indexPath
        configureImage(model.imageURL)
        configureDateLabel(model.date)
        configureLikeButton(model.isLiked)
    }
    
    private func addGradientView() {
        let gradientView = GradientView(frame: self.bounds)
        cellImageView.addSubview(gradientView)
        gradientView.animateGradientLayerLocations()
        self.gradientView = gradientView
    }
    
    private func removeGradientView() {
        gradientView?.removeAllAnimations()
        gradientView?.removeFromSuperview()
    }
    
    private func configureImage(_ url: String) {
        addGradientView()
        if let url = URL(string: url) {
            cellImageView.kf.setImage(with: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    state = .finished(value.image)
                case .failure(_):
                    state = .error
                    cellImageView.image = UIImage(named: "stub")
                }
                removeGradientView()
            }
        }
    }
    
    private func configureLikeButton(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_disable")
        likeButton.setImage(image, for: .normal)
    }
    
    private func configureDateLabel(_ date: Date?) {
        if let date = date {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
    }
    
    @objc private func likeButtonTapped() {
        guard let indexPath = indexPath else {
            assertionFailure("index path is nil")
            return
        }
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.likeButton.transform = .init(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                self.likeButton.transform = .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                self.likeButton.transform = .init(scaleX: 1.3, y: 1.3)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                self.likeButton.transform = .identity
            }
        }
        delegate?.likeButtonDidTapped(at: indexPath)
    }
    
    private func setupViews() {
        self.backgroundColor = .ypBlack
        self.selectionStyle = .none
        contentView.addSubview(mainView)
        mainView.addSubview(cellImageView)
        mainView.addSubview(likeButton)
        mainView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
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
            
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8),
            dateLabel.widthAnchor.constraint(equalToConstant: 152),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
