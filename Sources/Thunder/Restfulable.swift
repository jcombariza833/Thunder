//
//  Restfulable.swift
//  Thunder
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 1/14/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import Foundation
import Combine

public protocol Restfulable {
    static func send<T: Codable>(model: T.Type, _ request: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void)
    static func send<T: Codable>(model: T.Type, _ request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, RequestError>
}

