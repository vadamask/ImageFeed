//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation
import SwiftKeychainWrapper

struct OAuth2TokenStorage {
    static private let tokenKey = "token"
    
    static var bearerToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let newValue = newValue else {
                assertionFailure("token is wrong")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
}
