//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.07.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    var lastName: String?
    var bio: String?
}
