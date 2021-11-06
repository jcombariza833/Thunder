//
//  GetRequestBuilder.swift
//  Thunder
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 1/17/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import Foundation

public class RequestBuilder {

    private var request: URLRequest
    
    init(url: URL) {
        request = URLRequest(url: url)
    }
    
    func addCachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> RequestBuilder {
        request.cachePolicy = cachePolicy
        
        return self
    }
    
    func addTimeoutInterval(_ timeoutInterval: TimeInterval) -> RequestBuilder {
        request.timeoutInterval = timeoutInterval
        
        return self
    }
    
    func addHttpMethod(_ httpMethod: HTTPMethod) -> RequestBuilder {
        request.httpMethod = httpMethod.rawValue
        
        return self
    }
    
    func addAllHTTPHeaderFields(_ allHTTPHeaderFields: [String : String]) -> RequestBuilder {
        request.allHTTPHeaderFields = allHTTPHeaderFields
        
        return self
    }

    func addHttpBody(_ httpBody: Data) -> RequestBuilder {
        request.httpBody = httpBody
        
        return self
    }
    
    func addHttpBodyStream(_ httpBodyStream: InputStream) -> RequestBuilder {
        request.httpBodyStream = httpBodyStream
        
        return self
    }
    
    func addHttpShouldHandleCookies(_ httpShouldHandleCookies: Bool) -> RequestBuilder {
        request.httpShouldHandleCookies = httpShouldHandleCookies
        
        return self
    }
    
    func build() -> URLRequest {
        return request
    }
}
