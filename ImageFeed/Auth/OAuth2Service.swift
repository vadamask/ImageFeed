//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 24.06.2023.
//

import Foundation

final class OAuth2Service {
  enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
  }
  
  func fetchAuthToken(code: String, completion: @escaping (Result<Data, Error>) -> Void) {
    var urlComponents = URLComponents(string: AccessTokenURL)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: AccessKey),
      URLQueryItem(name: "client_secret", value: SecretKey),
      URLQueryItem(name: "redirect_uri", value: RedirectURI),
      URLQueryItem(name: "code", value: code),
      URLQueryItem(name: "grant_type", value: "authorization_code")
    ]
    let url = urlComponents.url!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        DispatchQueue.main.async {
          completion(.failure(error))
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
        DispatchQueue.main.async {
          completion(.success(data))
        }
      }
    }
    task.resume()
  }
}
