//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 05.08.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        if let url = authURL() {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL? {
        var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
  
        if let urlComponents = urlComponents,
           let url = urlComponents.url {
            return url
        } else {
            print("Failed to make URL from \(urlComponents as Any)")
            return nil
        }
    }
}
