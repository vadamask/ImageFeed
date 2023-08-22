//
//  PhotoViewMdoel.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.07.2023.
//

import Foundation

struct Image {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbURL: String
    let regularURL: String
    let largeURL: String
    var isLiked: Bool
}
