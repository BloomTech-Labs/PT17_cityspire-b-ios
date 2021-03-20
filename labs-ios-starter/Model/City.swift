//
//  City.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

struct City: Codable {
    var cityName: String
    var cityState: String
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var livability: Int?
    var walkability: Int?
    var traffic: Int?
    var crime: Int?
    var rentalPrice: Int?
    var pollution: Int?
    
    init(cityName: String, cityState: String) {
        self.cityName = cityName
        self.cityState = cityState
    }
}
