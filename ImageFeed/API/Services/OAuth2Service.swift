//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation

final class OAuth2Service {

    static let shared = OAuth2Service()
    var isLoading = false
    
    private let configuration = AuthConfiguration.standard
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    
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
            defer { self.task = nil }
            
            switch result {
            case .success(let tokenResponseBody):
                completion(.success(tokenResponseBody.accessToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
            self.isLoading = false
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(with code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: configuration.accessTokenURL) else {
            assertionFailure("Failed to make URLComponents from \(configuration.accessTokenURL)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "client_secret", value: configuration.secretKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
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
