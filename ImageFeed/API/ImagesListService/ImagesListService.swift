//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 20.07.2023.
//

import Foundation

final class ImagesListService {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    private init(){}
    private (set) var photos: [PhotoModel] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage.shared
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage.number + 1
        
        guard var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)", httpMethod: "GET"),
              let token = tokenStorage.bearerToken else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result{
            case .success(let photosInfo):
                let mapPhotos = photosInfo.map {
                    PhotoModel(id: $0.id,
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
                }
            case .failure(let error):
                assertionFailure(error.description(of: error))
            }
        }
        self.task = task
        lastLoadedPage = lastLoadedPage.number + 1
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool,_ completion: @escaping (Result<Void, Error>) -> Void) {
        
        var request: URLRequest?
        
        if isLike {
            request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: "DELETE")
        } else {
            request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: "POST")
        }
        
        guard var request = request,
              let token = tokenStorage.bearerToken else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError(error)))
                }
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200..<300 ~= response.statusCode) {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    }
                }
            }
            
            DispatchQueue.main.async {
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let oldPhoto = self.photos[index]
                    let newPhoto = PhotoModel(
                        id: oldPhoto.id,
                        size: oldPhoto.size,
                        createdAt: oldPhoto.createdAt,
                        welcomeDescription: oldPhoto.welcomeDescription,
                        thumbImageURL: oldPhoto.thumbImageURL,
                        largeImageURL: oldPhoto.largeImageURL,
                        isLiked: !oldPhoto.isLiked
                    )
                    self.photos[index] = newPhoto
                    completion(.success(()))
                } else {
                    assertionFailure("Photo not found")
                }
            }
        }
        task.resume()
    }
}
