//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation
import SwiftKeychainWrapper

struct OAuth2TokenStorage {
    static var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "token")
        }
        set {
            assert(newValue != "", "token is wrong")
            KeychainWrapper.standard.set(newValue!, forKey: "token")
        }
    }
}
