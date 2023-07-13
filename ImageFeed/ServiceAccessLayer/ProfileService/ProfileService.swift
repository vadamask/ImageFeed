//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.07.2023.
//

import Foundation

final class ProfileService {
    
    struct ProfileResult: Decodable {
        let username: String
        let firstName: String
        var lastName: String?
        var bio: String?
    }
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private(set) var profile: ProfileResult?
    
    static let shared = ProfileService()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET") else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                self.profile = profileResult
                completion(.success(profileResult))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
