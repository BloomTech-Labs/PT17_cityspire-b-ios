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

let airQualityDictionary: [String: String] = ["Good": "Excellent", "Moderate": "Good", "Unhealthy for Sensitive Groups": "Fair", "Unhealthy": "Fair", "Very Unhealthy": "Poor", "Hazardous": "Hazardous" ]

let propertyDescriptionDictionary: [String: String] =
    ["livability": "CitySpire's livability score is calculated using many of the city's attributes, and soon will be adjusted to your personal preferences to assess how well the city might fit your needs. Please visit the Settings page once this feature is available, to set your preferences.",
     "walkability": "A city's walkability score is determined by analyzing the distance to various amenities as well as the level of pedestrian friendliness. The score will be higher if most errands do not require a car and many amenities are located within a 5 minute walk. Lower scores indicate that fewer errands could be done on foot, and amenities are closer to 30 minutes away.",
     "diversityIndex": "The diversity index is derived from Simpson's Diversity Formula, which factors in the portion of the total population represented by each major  ethnicity group.",
     "crime": "The crime score comes from FBI data, and takes into account a variety of statistics. Some of the metrics used include: crime rate per 1,000 inhabitants, trends in crime over time, percentage of cases solved, and number of police personnel and total population.",
     "airQuality": "A city's air quality rating is displayed as follows.\nExcellent: Air quality poses little or no risk.\nGood: Air quality is acceptable, some risk to sensitive populations.\nFair: Members of sensitive groups may experience more health effects.\nPoor: Risk of health effects is increased.\nHazardous: Warning of emergency conditions.",
     "rentalPrice": "The rental price is displayed as an average of all apartments currently available in the city."]
