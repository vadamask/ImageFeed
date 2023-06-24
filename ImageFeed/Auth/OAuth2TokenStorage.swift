//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
  var token: String {
    get {
      guard let token = UserDefaults.standard.string(forKey: "token") else {
        assertionFailure("token error")
        return ""}
      return token
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "token")
    }
  }
}
