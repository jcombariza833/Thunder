//
//  ThunderTests.swift
//  ThunderTests
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 1/13/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import XCTest
import Combine

@testable import Thunder

class ThunderTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/todos/1"
        
        return components.url
    }

    override func setUp() {

    }

    override func tearDown() {
        
    }

    func testSuccesCoversionToData() {
        let testModelData = Thunder.parserToData(from: MockModel.decoderSuccess)
        
        XCTAssertNotNil(testModelData)
    }
    
    func testFailedCoversionToData() {
        let testModelData = Thunder.parserToData(from: MockModel.decoderFail)
        
        XCTAssertNil(testModelData)
    }
    
    func testParserWithParameter() {
        let data = Thunder.parserToData(from: MockModel.decoderSuccess)
        let model = Thunder.parser(from: data!, to: MockModel.self, dateFormat: .millisecondsSince1970)
        
        XCTAssertNotNil(model)
    }
    
    func testParserNonBadDateInput() {
        let data = Thunder.parserToData(from: MockModel.decoderSuccess)
        let model = Thunder.parser(from: data!, to: MockModel.self)
        
        XCTAssertNil(model)
    }
    
    func testSendSuccess() {
        guard let url = url else { return }
        let request = RequestBuilder(url: url).addHttpMethod(.get).build()
        
        let userExpectation = expectation(description: "user")
        var user: User?
        
        Thunder.send(model: User.self, request) { (result) in
            switch result {
            case .success( let model):
                user = model
                userExpectation.fulfill()
            case .failure( _ ):
                break
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(user)
        }
    }
    
    func testSendInvalidResponse() {
        guard let url = url else { return }
        let request = RequestBuilder(url: url).addHttpMethod(.get).build()
        
        let errorExpectation = expectation(description: "error")
        var requestError: RequestError?
        
        Thunder.send(model: MockModel.self, request) { (result) in
            switch result {
            case .success( _ ):
                break
            case .failure( let error ):
                requestError = error
                errorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(requestError)
            XCTAssertEqual(requestError, .invalidResponse)
        }
    }
    
    func testSendFailed() {
        guard let url = URL(string: "https://httpstat.us/404") else { return }
        let request = RequestBuilder(url: url).addHttpMethod(.post).build()
        
        let errorExpectation = expectation(description: "error")
        var requestError: RequestError?
        
        Thunder.send(model: User.self, request) { (result) in
            switch result {
            case .success( _ ):
                break
            case .failure(let error):
                requestError = error
                errorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(requestError)
            XCTAssertEqual(requestError, .requestFailed(404))
        }
    }
    
    
    func testSendReactSuccess() {
        guard let url = url else { return }
        let request = RequestBuilder(url: url).addHttpMethod(.get).build()
        
        let userExpectation = expectation(description: "user")
        var user: User?
        
        Thunder.send(model: User.self, request)
        .subscribe(on: DispatchQueue.global())
        .receive(on: OperationQueue.main)
        .sink(
            receiveCompletion: { completion in
            }, receiveValue: { model in
                user = model
                userExpectation.fulfill()
        })
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(user)
        }
    }
    
    func testSendReactInvalidResponse() {
        guard let url = url else { return }
        let request = RequestBuilder(url: url).addHttpMethod(.get).build()
        
        let errorExpectation = expectation(description: "error")
        var requestError: RequestError?
        
        Thunder.send(model: MockModel.self, request)
                .subscribe(on: DispatchQueue.global())
                .receive(on: OperationQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            requestError = error
                            errorExpectation.fulfill()
                        }
                    }, receiveValue: { model in

                })
                .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(requestError)
            XCTAssertEqual(requestError, .unableToMakeRequest)
        }
    }
    
    func testSendReactFailed() {
        guard let url = URL(string: "https://httpstat.us/404") else { return }
        let request = RequestBuilder(url: url).addHttpMethod(.post).build()
        
        let errorExpectation = expectation(description: "error")
        var requestError: RequestError?
        
        Thunder.send(model: User.self, request)
        .subscribe(on: DispatchQueue.global())
        .receive(on: OperationQueue.main)
        .sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    requestError = error
                    errorExpectation.fulfill()
                }
            }, receiveValue: { model in

        })
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(requestError)
            XCTAssertEqual(requestError, .requestFailed(404))
        }
    }
}
