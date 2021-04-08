//
//  NetworkModels.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 4/7/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

/// Struct to use when encoding data for api POST calls
struct PostCity: Encodable {
    let city: String
    let state: String
}

/// Information to display a city's walkability score
struct Walkability: Decodable {
    let walkability: Int
}
