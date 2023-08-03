//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureProgressHUD()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
    
    private func configureProgressHUD() {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .white
    }
}

