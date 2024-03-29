//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 09.06.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var photo: Image!
    private let alertPresenter = AlertPresenter()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .ypBlack
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .ypBlack
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "button_backward"), for: .normal)
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.accessibilityIdentifier = "BackButton"
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "button_sharing"), for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        alertPresenter.delegate = self
        loadPhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        setupConstraints()
    }
    
    private func loadPhoto() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: URL(string: photo.largeURL)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                rescaleAndCenterImageInScrollView(image: value.image)
            case .failure(let error):
                print(error.localizedDescription)
                showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlert() {
        let model = AlertModel(
            title: "Потеряно соединение",
            message: "Проверьте подключение к интернету и попробуйте еще раз",
            agreeButtonTitle: "Повторить",
            disagreeButtonTitle: "Отмена"
        )
        alertPresenter.showAlert(with: model, on: self)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        
        view.backgroundColor = .ypBlack
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.2
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.height / imageSize.height
        let wScale = visibleRectSize.width / imageSize.width
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, wScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton() {
        let activityVC = UIActivityViewController(
            activityItems: [imageView.image],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
    
    private func recenterImage() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ?
        (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        let verticalSpace = imageViewSize.height < scrollViewSize.height ?
        (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }
}

// MARK: - AlertPresenterDelegate

extension SingleImageViewController: AlertPresenterDelegate {
    func agreeAction() {
        loadPhoto()
    }
    
    func disagreeAction() {
        dismiss(animated: true)
    }
}
