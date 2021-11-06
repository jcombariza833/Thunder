//
//  RequestHelper.swift
//  Thunder
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 1/13/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import Foundation

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

typealias RestError = Int
private let nonSpecialError = 0

enum RequestError: Error, Identifiable, Equatable {
    var id: String { localizedDescription }
    
    case unableToMakeRequest
    case requestFailed(RestError)
    case invalidResponse
    case emptyResponse
}

enum HTTPMethod: String {
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case patch      = "PATCH"
    case delete     = "DELETE"
}

struct BasicRequest {
    
    static var thunderDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        return decoder
    }
    
    static func handleBasicResponse(with data: Data?, response: URLResponse?, error: Error?) -> Result<Data, RequestError> {
        if let _ = error {
            return .failure(.invalidResponse)
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return .failure(.requestFailed(nonSpecialError))
        }

        guard (200...299).contains(statusCode) else {
            return .failure(.requestFailed(statusCode))
        }
        
        guard let data = data else {
            return .failure(.emptyResponse)
        }
        
        return .success(data)
    }
    
    static func handleBasicResponse(with output: URLSession.DataTaskPublisher.Output) throws -> Data {

        guard let statusCode = (output.response as? HTTPURLResponse)?.statusCode else {
            throw RequestError.requestFailed(nonSpecialError)
        }

        guard (200...299).contains(statusCode) else {
            throw RequestError.requestFailed(statusCode)
        }
        
        return output.data
    }
}
