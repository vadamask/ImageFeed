//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 20.07.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    
    struct PhotoResult: Decodable {
        let id: String
        let width: Int
        let height: Int
        let createdAt: String
        let description: String?
        let urls: UrlsResult
        let likedByUser: Bool
    }
    
    struct UrlsResult: Decodable {
        let thumb: String
        let regular: String
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private init(){}
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage.shared
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
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
                let mapPhotos = photosInfo.map { parsePhotoInfo in
                    Photo(id: parsePhotoInfo.id,
                          size: CGSize(width: parsePhotoInfo.width, height: parsePhotoInfo.height),
                          createdAt: self.dateFormatter.date(from: parsePhotoInfo.createdAt),
                          welcomeDescription: parsePhotoInfo.description,
                          thumbImageURL: parsePhotoInfo.urls.thumb,
                          largeImageURL: parsePhotoInfo.urls.regular,
                          isLiked: parsePhotoInfo.likedByUser
                    )
                }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: mapPhotos)
                }
                NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        self.task = task
        lastLoadedPage = lastLoadedPage.number + 1
        task.resume()
    }
}
