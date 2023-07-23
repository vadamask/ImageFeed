//
//  PhotoViewMdoel.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.07.2023.
//

import Foundation

struct PhotoModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
