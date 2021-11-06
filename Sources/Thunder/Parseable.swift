//
//  Parseable.swift
//  Thunder
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 1/13/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import Foundation

protocol Parseable {
    static func parser<T: Codable>(from data: Data, to: T.Type, dateFormat: JSONDecoder.DateDecodingStrategy) -> T?
    static func parserToData<T: Codable>(from model: T) -> Data?
}
