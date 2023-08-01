//
//  Optional+Extensions.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 21.07.2023.
//

import Foundation

extension Optional where Wrapped == Int {
    var number: Int {
        switch self {
        case .some(let number):
            return number
        case .none:
            return 0
        }
    }
}

