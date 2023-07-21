//
//  Error+Extensions.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 21.07.2023.
//

import Foundation

extension Error {
    func description(of error: Error) -> String {
        switch error {
        case NetworkError.httpStatusCode(let code):
            return "Failed with status code from server - \(code)"
        case NetworkError.urlSessionError(let error):
            return "Failed with url session error - \(error)"
        case ParseError.decodeError(let error):
            return "Failed with decoding - \(error)"
        default:
            return "Unknown error - \(error)"
        }
    }
}
