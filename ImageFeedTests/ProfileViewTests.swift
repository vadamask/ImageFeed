//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Вадим Шишков on 06.08.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsAddObserver() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
       
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.addObserverCalled)
    }
    
    func testViewControllerCallsRemoveObserver() {
        // given
        var viewController: ProfileViewController? = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController?.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController = nil
        
        // then
        XCTAssertTrue(presenter.removeObserverCalled)
    }
   
    func testConvertResultToViewModel() {
        // given
        let presenter = ProfileViewPresenter(profileService: StubProfileService.shared)
        
        // when
        let model = presenter.convertResultToViewModel()
        
        // then
        XCTAssertEqual(model?.name, "Vadim Shishkov")
        XCTAssertEqual(model?.userName, "@vadamask")
        XCTAssertEqual(model?.description, "ios developer")
    }
    
    func testPresenterCallsShowAlert() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(
            profileService: StubProfileService.shared,
            profileImageService: ProfileImageService.shared
        )
        viewController.presenter = presenter
        presenter.view = viewController
       
        // when
        presenter.didTapLogoutButton()
        
        // then
        XCTAssertTrue(viewController.showAlertControllerCalled)
    }
    
    func testPresenterCallsSetAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(
            profileService: StubProfileService.shared,
            profileImageService: StubProfileImageService.shared
        )
        viewController.presenter = presenter
        presenter.view = viewController
       
        // when
        presenter.checkImageURL()
        
        // then
        XCTAssertTrue(viewController.setAvatarCalled)
        XCTAssertEqual(viewController.url?.absoluteString, "example.com")
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var addObserverCalled = false
    var removeObserverCalled = false
    
    func addObserverForImageURL() {
        addObserverCalled = true
    }
    func removeObserverForImageURL() {
        removeObserverCalled = true
    }
    func cleanAndSwitchToSplashVC() {}
    func didTapLogoutButton() {}
    
    func convertResultToViewModel() -> ProfileViewModel? {
        return nil
    }
    
    func checkImageURL() {}
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var showAlertControllerCalled = false
    var setAvatarCalled = false
    var url: URL?
    
    func showAlertController(_ alertController: UIAlertController) {
        showAlertControllerCalled = true
    }
    func setAvatar(_ url: URL) {
        setAvatarCalled = true
        self.url = url
    }
}

final class StubProfileService: ProfileServiceProtocol {
    static var shared: ProfileServiceProtocol = StubProfileService()
    var profile: ProfileResult? = ProfileResult(username: "vadamask", firstName: "Vadim", lastName: "Shishkov", bio: "ios developer")

    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
    }
}

final class StubProfileImageService: ProfileImageServiceProtocol {
    static var shared: ProfileImageServiceProtocol = StubProfileImageService()
    
    var avatarURL: String? = "example.com"
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
}
