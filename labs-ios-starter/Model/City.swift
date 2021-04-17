//
//  City.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

struct City: Decodable {
    
    enum Keys: String, CodingKey {
        case latitude
        case longitude
        case rental_price
        case crime
        case air_quality_index
        case population
        case diversity_index
        case walkability
        case livability
        case recommendations
        
        enum recommendationKeys: String, CodingKey {
            case city
            case state
            case latitude
            case longitude
        }
    }
    
    var cityName: String
    var cityState: String
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var population: Int?
    var livability: Int?
    var walkability: Int?
    var diversityIndex: Int?
    var crime: String?
    var rentalPrice: Int?
    var airQuality: String?
    var recommendations: [Recommendation] = []
    var weather: Weather? = nil
    
    init(cityName: String, cityState: String) {
        self.cityName = cityName
        self.cityState = cityState
    }
    
    init(from decoder: Decoder) throws {
        cityName = "City"
        cityState = "State"
        let container = try decoder.container(keyedBy: Keys.self)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        population = try container.decodeIfPresent(Int.self, forKey: .population)
        livability = try container.decodeIfPresent(Int.self, forKey: .livability)
        walkability = try container.decodeIfPresent(Int.self, forKey: .walkability)
        diversityIndex = try container.decodeIfPresent(Int.self, forKey: .diversity_index)
        crime = try container.decodeIfPresent(String.self, forKey: .crime)
        rentalPrice = try container.decodeIfPresent(Int.self, forKey: .rental_price)
        airQuality = try container.decodeIfPresent(String.self, forKey: .air_quality_index)
        if let air = airQuality {
            if let airQualityWord = airQualityDictionary[air] {
                airQuality = airQualityWord
            } else {
                airQuality = "Good"
            }
        }
        recommendations = try container.decodeIfPresent([Recommendation].self, forKey: .recommendations) ?? []
    }
}
