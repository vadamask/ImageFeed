//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.07.2023.
//

import Foundation

final class ProfileService {
    
    private struct ProfileResult: Decodable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String
    }
    
    struct ProfileViewModel {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private(set) var profile: ProfileViewModel?
    
    static let shared = ProfileService()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileViewModel, Error>) -> Void) {
        
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
                let profile = ProfileViewModel(
                    username: profileResult.username,
                    name: "\(profileResult.firstName) \(profileResult.lastName)",
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio
                )
                completion(.success(profile))
                self.profile = profile
                self.task = nil
            case .failure(let error):
                self.task = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
