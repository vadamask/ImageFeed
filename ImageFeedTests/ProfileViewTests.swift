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
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var addObserverCalled = false
    var removeObserverCalled = false
    
    func addObserver() {
        addObserverCalled = true
    }
    func removeObserver() {
        removeObserverCalled = true
    }
    func cleanAndSwitchToSplashVC() {}
    func didTapLogoutButton() {}
    
    func convertResultToViewModel() -> ProfileViewModel? {
        return nil
    }
    
    func checkImageURL() {}
}

final class StubProfileService: ProfileServiceProtocol {
    static var shared: ProfileServiceProtocol = StubProfileService()
    var profile: ProfileResult? = ProfileResult(username: "vadamask", firstName: "Vadim", lastName: "Shishkov", bio: "ios developer")

    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
    }
}
