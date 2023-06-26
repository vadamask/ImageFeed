//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
  var token: String? {
    get {
      UserDefaults.standard.string(forKey: "token")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "token")
    }
  }
}
