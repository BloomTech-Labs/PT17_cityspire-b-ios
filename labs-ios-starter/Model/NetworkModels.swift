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

struct WeatherMonth: Decodable {
    enum Keys: String, CodingKey {
        case date
        case min_temperature
        case max_temperature
    }
    
    let month: String?
    let minTemp: Double
    let maxTemp: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM"
            month = formatter.string(from: date)
        } else {
            month = ""
        }
        minTemp = try container.decode(Double.self, forKey: .min_temperature)
        maxTemp = try container.decode(Double.self, forKey: .max_temperature)
    }
}

struct Weather: Decodable {
    enum Keys: String, CodingKey {
        case weather_temperature
    }
    
    var months: [WeatherMonth]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        months = try container.decode([WeatherMonth].self, forKey: .weather_temperature)
        while months.count > 12 {
            let _ = months.popLast()
        }
    }
}
