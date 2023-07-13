//
//  Constants.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import Foundation

enum Constants {
    static let accessKey = "g8xe9PSjkW42pFo8h1NKaKm8jIgGUmXmsl1AyqEijUw"
    static let secretKey = "sYje4YYUNhnGUpPjQt-7pJmMIMUYkf-KMwSPyVqXiB0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let accessTokenURL = "https://unsplash.com/oauth/token"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
