//
//  URLRequestTests.swift
//  ImageFeedTests
//
//  Created by Вадим Шишков on 08.08.2023.
//

import XCTest
@testable import ImageFeed

class URLRequestTests: XCTestCase {
    func testMakingRequest() {
        // given
        let path = "/me"
        let method = "GET"
        
        // when
        let request = URLRequest.makeHTTPRequest(path: path, httpMethod: method)!
        
        // then
        XCTAssertEqual(request.httpMethod, method)
        XCTAssertEqual(request.url!.path(), path)
    }
}
