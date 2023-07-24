//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "token"
    private init(){}
    var bearerToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let newValue = newValue else {
                assertionFailure("token = nil")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
}
