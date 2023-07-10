//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation

fileprivate let accessTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
    }

    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    
    static let shared = OAuth2Service()
    var isLoading = false
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = makeRequest(with: code) else {
            assertionFailure("Failed to make request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let tokenResponseBody):
                completion(.success(tokenResponseBody.accessToken))
                self.task = nil
            case .failure(let error):
                self.lastCode = nil
                self.task = nil
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(with code: String) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: accessTokenURL) else {
            assertionFailure("Failed to make URLComponents from \(accessTokenURL)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to make URL from \(urlComponents)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
