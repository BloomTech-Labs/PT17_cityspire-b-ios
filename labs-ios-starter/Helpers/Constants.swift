//
//  Constants.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

enum ReuseIdentifier {
    static let poiAnnotation = "poiAnnotationView"
    static let favAnnotation = "favAnnotationView"
    static let poiTableViewCell = "poiCell"
    static let homeScreenCell = "homeScreenCell"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case failedLogin
    case noToken
    case tryAgain
    case failedDecoding
    case failedEncoding
    case failedResponse
    case noIdentifier
    case noRep
    case otherError
}
