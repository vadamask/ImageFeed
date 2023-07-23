//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.07.2023.
//

import Foundation

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
