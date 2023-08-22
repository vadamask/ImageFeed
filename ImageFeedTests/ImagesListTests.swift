//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Вадим Шишков on 07.08.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testFetchPhotosAfterViewDidLoad() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertEqual(presenter.numberOfRowsInSection(), 10)
    }
    
    func testHeightForRow() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.viewDidLoad()
        
        // when
        let height = presenter.heightForRow(at: IndexPath(row: 0, section: 0), with: 324)
        
        // then
        XCTAssertEqual(height, 300)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPresenterCallsReloadRows() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        // when
        presenter.likeDidTapped(at: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(viewController.reloadRowsDidCalled)
    }
    
    func testCreateModelFromPhoto() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.viewDidLoad()
        
        // when
        let model = presenter.modelForCell(at: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(model.imageURL, "regularURL")
        XCTAssertEqual(model.isLiked, false)
        XCTAssertEqual(model.date, nil)
    }
    
    func testPresenterCallsShowSingleImageVC() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        // when
        presenter.rowDidSelect(at: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(viewController.showSingleImageVCCalled)
    }
    
    func testFetchPhotosAfterLastIndex() {
        // given
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        presenter.viewDidLoad()
        
        // when
        presenter.cellWillDisplay(at: IndexPath(row: 9, section: 0))
        
        // then
        XCTAssertEqual(presenter.numberOfRowsInSection(), 20)
    }
    
    func testPresenterCallsProgressHUD() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImagesListServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        // when
        presenter.likeDidTapped(at: IndexPath(row: 0, section: 0))
        // then
        XCTAssertTrue(viewController.showProgressHUDCalled)
        XCTAssertTrue(viewController.dismissProgressHUDCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    func modelForCell(at indexPath: IndexPath) -> ImagesListCellModel {
        ImagesListCellModel(imageURL: "example.com", isLiked: true, date: Date())
    }
    func numberOfRowsInSection() -> Int { 0 }
    func heightForRow(at indexPath: IndexPath, with tableViewWidth: CGFloat) -> CGFloat { 0 }
    func rowDidSelect(at indexPath: IndexPath) {}
    func cellWillDisplay(at indexPath: IndexPath) {}
    func likeDidTapped(at indexPath: IndexPath) {}
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    var showSingleImageVCCalled = false
    var showProgressHUDCalled = false
    var dismissProgressHUDCalled = false
    var reloadRowsDidCalled = false
    
    func updateTableViewAnimated(at indexPaths: [IndexPath]) {
        updateTableViewAnimatedCalled = true
    }
    func showSingleImageVC(_ vc: ImageFeed.SingleImageViewController) {
        showSingleImageVCCalled = true
    }
    func reloadRows(at indexPaths: [IndexPath]) {
        reloadRowsDidCalled = true
    }
    func showProgressHUD() {
        showProgressHUDCalled = true
    }
    func dismissProgressHUD() {
        dismissProgressHUDCalled = true
    }
    func dismissAlert() {}
}

final class ImagesListServiceStub: ImagesListServiceProtocol {
    static var shared: ImagesListServiceProtocol = ImagesListServiceStub()
    var photos: [Image] = []
    let stubPhotos = Array(
        repeating: (
            Image(id: "1",
                  size: CGSize(width: 400, height: 400),
                  createdAt: nil, welcomeDescription: nil,
                  thumbURL: "thumbURL",
                  regularURL: "regularURL",
                  largeURL: "largeURL", isLiked: false)
        ), count: 10)
    
    func fetchPhotosNextPage(completion: @escaping (Result<Int, Error>) -> Void) {
        photos.append(contentsOf: stubPhotos)
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
    }
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}
