//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 20.07.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    static var shared: ImagesListServiceProtocol { get }
    var photos: [Photo] { get }
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void)
    func changeLike(photoId: String, isLiked: Bool,_ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    
    private lazy var dateFormatter = {
        return ISO8601DateFormatter()
    }()
    
    private init(){}
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage.shared
    
    static let shared: ImagesListServiceProtocol = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage.number + 1
        
        guard var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)", httpMethod: "GET"),
              let token = tokenStorage.bearerToken else {
            print("Failed to make HTTP request")
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            defer { self.task = nil }
            
            switch result{
            case .success(let photosData):
                let mapPhotos = photosData.map {
                    Photo(id: $0.id,
                          size: CGSize(width: $0.width, height: $0.height),
                          createdAt: self.dateFormatter.date(from: $0.createdAt),
                          welcomeDescription: $0.description,
                          thumbImageURL: $0.urls.thumb,
                          largeImageURL: $0.urls.full,
                          isLiked: $0.likedByUser
                    )
                }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: mapPhotos)
                    NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
                    completion(.success(Void()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        lastLoadedPage = lastLoadedPage.number + 1
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool,_ completion: @escaping (Result<Void, Error>) -> Void) {
        let request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: isLiked ? "DELETE" : "POST")
        
        guard var request = request,
              let token = tokenStorage.bearerToken else {
            print("Failed to make HTTP request")
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let self = self else { return }
            
            if let response = response as? HTTPURLResponse {
                let code = response.statusCode
                
                if 200..<300 ~= code {
                    DispatchQueue.main.async {
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            var photo = self.photos[index]
                            photo.isLiked.toggle()
                            self.photos[index] = photo
                            completion(.success(Void()))
                        } else {
                            completion(.failure(AppError.photoNotFound(photoId: photoId)))
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
                completion(.failure(NetworkError.unknownError))
            }
        }
        task.resume()
    }
}
