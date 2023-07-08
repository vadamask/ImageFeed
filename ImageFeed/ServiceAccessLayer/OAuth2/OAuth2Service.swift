//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation

fileprivate let accessTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError(Error)
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard var urlComponents = URLComponents(string: accessTokenURL) else {
            assertionFailure("Failed to make URLComponents from \(accessTokenURL)")
            return
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
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError(error)))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 || response.statusCode >= 300 {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    }
                    return
                }
            }
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    DispatchQueue.main.async {
                        print(responseBody.accessToken)
                        completion(.success(responseBody.accessToken))
                    }
                } catch {
                    assertionFailure("Decode error - \(error)")
                }
            }
        }
        task.resume()
    }
}
