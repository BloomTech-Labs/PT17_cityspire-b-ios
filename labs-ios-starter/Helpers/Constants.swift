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

let propertyDescriptionDictionary: [String: String] =
    ["livability": "CitySpire's livability score is calculated using many of the city's attributes, and soon will be adjusted to your personal preferences to assess how well the city might fit your needs. Please visit the Settings page once this feature is available, to set your preferences.",
     "walkability": "A city's walkability score is determined by analyzing the distance to various amenities as well as the level of pedestrian friendliness. The score will be higher if most errands do not require a car and many amenities are located within a 5 minute walk. Lower scores indicate that fewer errands could be done on foot, and amenities are closer to 30 minutes away.",
     "diversityIndex": "The diversity index comes from...",
     "crime": "The crime score...",
     "airQuality": "A city's air quality rating...",
     "rentalPrice": "The average rental price of..."]
