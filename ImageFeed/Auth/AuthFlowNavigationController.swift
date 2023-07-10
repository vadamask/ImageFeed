//
//  AuthFlowNavigationController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 10.07.2023.
//

import UIKit

final class AuthFlowNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        visibleViewController
    }
}
