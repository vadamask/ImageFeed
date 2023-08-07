//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 06.08.2023.
//

import UIKit

protocol ImagesListPresenterProtocol: UITableViewDataSource, UITableViewDelegate {
    var view: ImagesListViewControllerProtocol? { get }
    func fetchPhotosNextPage()
    func addObserver()
}

final class ImagesListPresenter: NSObject, ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func addObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.calculateIndexPaths()
            }
        )
    }
    
    private func calculateIndexPaths() {
        let startIndex = photos.count
        let lastIndex = imagesListService.photos.count-1
        photos.append(contentsOf: imagesListService.photos[startIndex...lastIndex])
        
        let indexPaths = (startIndex...lastIndex).map {
            IndexPath(row: $0, section: 0)
        }
        view?.updateTableViewAnimated(at: indexPaths)
    }
}

//MARK: - UITableViewDataSource

extension ImagesListPresenter {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            preconditionFailure("Casting error")
        }
        imageListCell.delegate = self
        let model = ImagesListCellModel(
            imageURL: photos[indexPath.row].thumbImageURL,
            imageIsLiked: photos[indexPath.row].isLiked,
            date: photos[indexPath.row].createdAt
        )
        imageListCell.configure(with: model, at: indexPath)
        return imageListCell
    }
}

//MARK: - UITableViewDelegate

extension ImagesListPresenter {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let imageHeight = size.height * scale
        let imageViewHeight = imageHeight + imageInsets.top + imageInsets.bottom
        return imageViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = SingleImageViewController()
        let photo = photos[indexPath.row]
        vc.photo = photo
        vc.modalPresentationStyle = .fullScreen
        view?.showSingleImageVC(vc)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

//MARK: - ImagesListCellDelegate

extension ImagesListPresenter: ImagesListCellDelegate {
    func imagesListCellDidTapLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.showProgressHUD()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.photos[indexPath.row] = imagesListService.photos[indexPath.row]
                view?.reloadRows(at: [indexPath])
            case .failure(let error):
                assertionFailure(error.description(of: error))
            }
            view?.dismissProgressHUD()
        }
    }
}
