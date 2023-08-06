//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 11.07.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        let imagesListViewController = ImagesListViewController()
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
