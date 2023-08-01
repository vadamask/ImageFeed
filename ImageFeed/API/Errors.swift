//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 10.07.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlSessionError(Error)
}

enum ParseError: Error {
    case decodeError(Error)
}

