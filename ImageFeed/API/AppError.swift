//
//  AppError.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 15.08.2023.
//

import Foundation

enum AppError: Error {
    case photoNotFound(photoId: String)
}
