//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 10.07.2023.
//

import Foundation

extension URLSession {
    
    func objectTask<DecodingType: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<DecodingType, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(DecodingType.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(NetworkError.decodeError(error)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError(error)))
                }
            } else {
                assertionFailure("Unknown error")
            }
        }
        return task
    }
}
