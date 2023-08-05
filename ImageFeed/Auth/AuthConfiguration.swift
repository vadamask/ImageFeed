//
//  Constants.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import Foundation

let AccessKey = "g8xe9PSjkW42pFo8h1NKaKm8jIgGUmXmsl1AyqEijUw"
let SecretKey = "sYje4YYUNhnGUpPjQt-7pJmMIMUYkf-KMwSPyVqXiB0"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")
let AccessTokenURL = "https://unsplash.com/oauth/token"
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let accessTokenURL: String
    let unsplashAuthorizeURLString: String
    
    static var shared: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseURL: DefaultBaseURL,
            accessTokenURL: AccessTokenURL,
            unsplashAuthorizeURLString: UnsplashAuthorizeURLString
        )
    }
}
