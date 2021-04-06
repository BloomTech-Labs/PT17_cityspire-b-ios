//
//  Recommendation.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/22/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

/// used in both the City model for its recommendations array, and as the basic data structure for the TopCities array
struct Recommendation: Codable {
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    
    init(city: String, state: String, latitude: Double, longitude: Double) {
        self.city = city
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// an array: [Recommendation], used to decode the top cities array for display on HomeScreenVC
struct TopCities: Codable {
    
    enum Keys: String, CodingKey {
        case top_cities
    }
    
    var top_cities: [Recommendation]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        top_cities = try container.decodeIfPresent([Recommendation].self, forKey: .top_cities) ?? []
    }
}
