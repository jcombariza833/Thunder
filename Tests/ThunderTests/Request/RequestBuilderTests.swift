//
//  RequestBuilderTests.swift
//  ThunderTests
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 5/29/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import XCTest

class RequestBuilderTests: XCTestCase {
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/todos/1"
        
        return components.url
    }

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {

    }

    func testInitialization() throws {
        guard let url = self.url else { return }
        let request = RequestBuilder(url: url)
        
        XCTAssertNotNil(request)
    }
    
    func testDefaultRequest() throws {
        guard let url = self.url else { return }
        let request = RequestBuilder(url: url).build()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(url, request.url)
        XCTAssertEqual(URLRequest.CachePolicy.useProtocolCachePolicy, request.cachePolicy)
        XCTAssertEqual(60.0, request.timeoutInterval)
        XCTAssertEqual("GET", request.httpMethod)
        XCTAssertNil(request.allHTTPHeaderFields)
        XCTAssertNil(request.httpBody)
        XCTAssertNil(request.httpBodyStream)
        XCTAssertTrue(request.httpShouldHandleCookies)
    }
    
    func testCustomRequestBody() throws {
        let headers = ["Content-Type":"application/json; charset=utf-8"]
        guard let url = self.url else { return }
        let request = RequestBuilder(url: url)
            .addCachePolicy(URLRequest.CachePolicy.reloadIgnoringCacheData)
            .addTimeoutInterval(10.0)
            .addHttpMethod(.post)
            .addAllHTTPHeaderFields(headers)
            .addHttpBody("test data".data(using: .utf8) ?? Data())
            .addHttpShouldHandleCookies(false)
            .build()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(url, request.url)
        XCTAssertEqual(URLRequest.CachePolicy.reloadIgnoringCacheData, request.cachePolicy)
        XCTAssertEqual(10.0, request.timeoutInterval)
        XCTAssertEqual("POST", request.httpMethod)
        XCTAssertEqual(headers, request.allHTTPHeaderFields)
        XCTAssertNotNil(request.httpBody)
        XCTAssertFalse(request.httpShouldHandleCookies)
    }
    
     func testCustomRequestBodyStream() throws {
            let headers = ["Content-Type":"application/json; charset=utf-8"]
            guard let url = self.url else { return }
            let request = RequestBuilder(url: url)
                .addCachePolicy(URLRequest.CachePolicy.reloadIgnoringCacheData)
                .addTimeoutInterval(10.0)
                .addHttpMethod(.post)
                .addAllHTTPHeaderFields(headers)
                .addHttpBodyStream(InputStream(data: Data()))
                .addHttpShouldHandleCookies(false)
                .build()
            
            XCTAssertNotNil(request)
            XCTAssertEqual(url, request.url)
            XCTAssertEqual(URLRequest.CachePolicy.reloadIgnoringCacheData, request.cachePolicy)
            XCTAssertEqual(10.0, request.timeoutInterval)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertEqual(headers, request.allHTTPHeaderFields)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertFalse(request.httpShouldHandleCookies)
        }

}
