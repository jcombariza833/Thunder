//
//  RequestHelperTests.swift
//  ThunderTests
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 5/29/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import XCTest

class RequestHelperTests: XCTestCase {
    
    typealias MockOutput = (data: Data, response: URLResponse)
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testNormalRequestNil() throws {
        switch BasicRequest.handleBasicResponse(with: nil, response: nil, error: nil) {
        case .success( _ ):
            break
        case .failure(let error):
            XCTAssertEqual(error, .requestFailed(0))
        }
    }
    
    func testNormalRequestError() throws {
        switch BasicRequest.handleBasicResponse(with: nil, response: nil, error: RequestError.invalidResponse) {
        case .success( _ ):
            break
        case .failure(let error):
            XCTAssertEqual(error, .invalidResponse)
            XCTAssertNotNil(error.id)
        }
    }
    
    func testNormalRequestInvalidCode() throws {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 100, httpVersion: nil, headerFields: nil)
        
        switch BasicRequest.handleBasicResponse(with: nil, response: urlResponse, error: nil) {
        case .success( _ ):
            break
        case .failure(let error):
            XCTAssertEqual(error, .requestFailed(100))
            XCTAssertNotNil(error.id)
        }
    }
    
    func testNormalRequestNoData() throws {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        switch BasicRequest.handleBasicResponse(with: nil, response: urlResponse, error: nil) {
        case .success( _ ):
            break
        case .failure(let error):
            XCTAssertEqual(error, .emptyResponse)
            XCTAssertNotNil(error.id)
        }
    }
    
    func testNormalRequestSuccessData() throws {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "test data".data(using: .utf8) ?? Data()
        
        switch BasicRequest.handleBasicResponse(with: data, response: urlResponse, error: nil) {
        case .success( let dataResponse ):
            XCTAssertEqual(dataResponse, data)
        case .failure( _ ):
            break
        }
    }
    
    func testDecoder() throws {
        XCTAssertNotNil(BasicRequest.thunderDecoder)
    }

    func testReactRequestNilResponseData() throws {
        let urlResponse = URLResponse()
        let data = "test data".data(using: .utf8) ?? Data()
        let monckResponse = MockOutput(data: data, response: urlResponse)
        
        XCTAssertThrowsError(try BasicRequest.handleBasicResponse(with: monckResponse)) { error in
            XCTAssertEqual(error as? RequestError, RequestError.requestFailed(0))
        }
    }
    
    func testReactRequestBadCode() throws {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 100, httpVersion: nil, headerFields: nil)
        let data = "test data".data(using: .utf8) ?? Data()
        let monckResponse = MockOutput(data: data, response: urlResponse!)
        
        XCTAssertThrowsError(try BasicRequest.handleBasicResponse(with: monckResponse)) { error in
            XCTAssertEqual(error as? RequestError, RequestError.requestFailed(100))
        }
    }
    
    func testReactRequestSuccess() throws {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "test data".data(using: .utf8) ?? Data()
        let monckResponse = MockOutput(data: data, response: urlResponse!)
        let dataResponse = try BasicRequest.handleBasicResponse(with: monckResponse)
        
        XCTAssertEqual(data, dataResponse)
    }
}
