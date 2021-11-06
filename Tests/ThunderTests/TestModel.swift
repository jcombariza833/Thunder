//
//  File.swift
//  ThunderTests
//
//  Created by JUAN PABLO COMBARIZA MEJIA on 1/25/20.
//  Copyright © 2020 JUAN PABLO COMBARIZA MEJIA. All rights reserved.
//

import Foundation

struct MockModel: Codable {
    var atributteDouble: Double
    var atributteString: String
    var atributteDate: Date
}

extension MockModel {
    static let decoderSuccess = MockModel(atributteDouble: 10.0,
                                          atributteString: "string",
                                          atributteDate: Date())
    
    static let decoderFail = MockModel(atributteDouble: Double.infinity,
                                       atributteString: "string",
                                       atributteDate: Date())
}

struct User: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
