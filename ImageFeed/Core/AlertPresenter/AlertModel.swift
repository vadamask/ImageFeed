//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 20.08.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let agreeButtonTitle: String
    var disagreeButtonTitle: String? = nil
}
