//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 08.07.2023.
//

import Foundation

final class ProfileImageService {
    
    private struct UserResult: Decodable {
        let profileImage: ProfileImage
    }
    
    private struct ProfileImage: Decodable {
        let small: String
        let medium: String
        let large: String
    }
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    private let urlSession = URLSession.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET"),
              let token = OAuth2TokenStorage.bearerToken else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                completion(.success(user.profileImage.medium))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": user.profileImage.medium]
                )
                self.avatarURL = user.profileImage.medium
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
