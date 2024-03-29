//
//  File.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.07.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
