//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Вадим Шишков on 07.08.2023.
//

import XCTest
@testable import ImageFeed

class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsAddObserver() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.addObserverCalled)
    }
    
    func testViewControllerCallsFetchPhotos() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testNumberOfRowInSection() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.addObserver()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // when
        let rows = presenter.numberOfRowsInSection()
        
        // then
        XCTAssertEqual(rows, 3)
    }
    
    func testHeightForRow() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.addObserver()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // when
        let height = presenter.heightForRow(at: IndexPath(row: 0, section: 0), with: 200)
        
        // then
        XCTAssertEqual(height, 176)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.addObserver()
        
        // when
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testCreateModelFromPhoto() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.addObserver()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // when
        let model = presenter.createModel(at: IndexPath(row: 1, section: 0))
        
        // then
        XCTAssertEqual(model.imageURL, "thumb2")
        XCTAssertEqual(model.imageIsLiked, false)
        XCTAssertEqual(model.date, nil)
    }
    
    func testPresenterCallsShowSingleImageVC() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.addObserver()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // when
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(viewController.showSingleImageVCCalled)
    }
    
    func testFetchPhotosAfterLastIndex() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.addObserver()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // when
        presenter.willDisplayCell(at: IndexPath(row: 2, section: 0))
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        
        // then
        XCTAssertEqual(presenter.numberOfRowsInSection(), 4)
    }
    
    func testPresenterCallsProgressHUD() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.addObserver()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.likeDidTapped(at: IndexPath(row: 0, section: 0))
        // then
        XCTAssertTrue(viewController.showProgressHUDCalled)
        XCTAssertTrue(viewController.dismissProgressHUDCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var addObserverCalled = false
    var fetchPhotosNextPageCalled = false
    
    func numberOfRowsInSection() -> Int {
        0
    }
    
    func heightForRow(at indexPath: IndexPath, with tableViewWidth: CGFloat) -> CGFloat {
        0
    }
    func didSelectRow(at indexPath: IndexPath) {}
    
    func willDisplayCell(at indexPath: IndexPath) {}
    
    func likeDidTapped(at indexPath: IndexPath) {}
    
    func createModel(at indexPath: IndexPath) -> ImagesListCellModel {
        ImagesListCellModel(imageURL: "example.com", imageIsLiked: true, date: Date())
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func addObserver() {
        addObserverCalled = true
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    var showSingleImageVCCalled = false
    var showProgressHUDCalled = false
    var dismissProgressHUDCalled = false
    
    func updateTableViewAnimated(at indexPaths: [IndexPath]) {
        updateTableViewAnimatedCalled = true
    }
    
    func showSingleImageVC(_ vc: ImageFeed.SingleImageViewController) {
        showSingleImageVCCalled = true
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {}
    
    func showProgressHUD() {
        showProgressHUDCalled = true
    }
    
    func dismissProgressHUD() {
        dismissProgressHUDCalled = true
    }
}

final class ImagesListServiceStub: ImagesListServiceProtocol {
    static var shared: ImagesListServiceProtocol = ImagesListServiceStub()
    
    var photos: [Photo] = [
        Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: nil, welcomeDescription: nil, thumbImageURL: "thumb1", largeImageURL: "large1", isLiked: true),
        Photo(id: "2", size: CGSize(width: 200, height: 200), createdAt: nil, welcomeDescription: nil, thumbImageURL: "thumb2", largeImageURL: "large2", isLiked: false),
        Photo(id: "3", size: CGSize(width: 300, height: 300), createdAt: nil, welcomeDescription: nil, thumbImageURL: "thumb3", largeImageURL: "large3", isLiked: true)
    ]
    
    func fetchPhotosNextPage() {
        photos.append(Photo(id: "4", size: CGSize(width: 400, height: 400), createdAt: nil, welcomeDescription: nil, thumbImageURL: "thumb4", largeImageURL: "large4", isLiked: false))
        
    }
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}
