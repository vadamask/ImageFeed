//
//  File.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.07.2023.
//

import Foundation

struct ProfileImageResult: Decodable {
    let profileImage: Size
}

struct Size: Decodable {
    let small: String
    let medium: String
    let large: String
}
