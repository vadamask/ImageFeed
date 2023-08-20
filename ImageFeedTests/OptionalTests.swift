//
//  OptionalTests.swift
//  ImageFeedTests
//
//  Created by Вадим Шишков on 08.08.2023.
//

import XCTest
@testable import ImageFeed

final class OptionalTests: XCTestCase {
    func testGetNumberFromInt() {
        // given
        let optionalNumber: Int? = 5
        let optionalNil: Int? = nil
        
        // when
        let valueFromNumber = optionalNumber.number
        let valueFromNil = optionalNil.number
        
        // then
        XCTAssertEqual(valueFromNumber, 5)
        XCTAssertEqual(valueFromNil, 0)
    }
}

