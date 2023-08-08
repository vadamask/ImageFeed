//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 06.08.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get }
    func numberOfRowsInSection() -> Int
    func heightForRow(at indexPath: IndexPath, with tableViewWidth: CGFloat) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func likeDidTapped(at indexPath: IndexPath)
    func createModel(at indexPath: IndexPath) -> ImagesListCellModel
    func fetchPhotosNextPage()
    func addObserver()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
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
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func numberOfRowsInSection() -> Int {
        photos.count
    }
    
    func heightForRow(at indexPath: IndexPath, with tableViewWidth: CGFloat) -> CGFloat {
        let size = photos[indexPath.row].size
        let imageViewWidth = tableViewWidth - 32
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let imageHeight = size.height * scale
        let imageViewHeight = imageHeight + 8
        return imageViewHeight
    }
    
    func createModel(at indexPath: IndexPath) -> ImagesListCellModel {
        ImagesListCellModel(
            imageURL: photos[indexPath.row].thumbImageURL,
            imageIsLiked: photos[indexPath.row].isLiked,
            date: photos[indexPath.row].createdAt
        )
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let vc = SingleImageViewController()
        let photo = photos[indexPath.row]
        vc.photo = photo
        vc.modalPresentationStyle = .fullScreen
        view?.showSingleImageVC(vc)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func likeDidTapped(at indexPath: IndexPath) {
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
    
    private func calculateIndexPaths() {
        let startIndex = photos.count
        let lastIndex = imagesListService.photos.count
        photos.append(contentsOf: imagesListService.photos[startIndex..<lastIndex])
        
        let indexPaths = (startIndex..<lastIndex).map {
            IndexPath(row: $0, section: 0)
        }
        view?.updateTableViewAnimated(at: indexPaths)
    }
}
