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

struct Housing: Decodable {
    enum Keys: String, CodingKey {
        case singleFamily = "single_family_housing_avg_price"
        case condo = "condo_avg_price"
        case oneBedroom = "1_bedroom_avg_price"
        case twoBedroom = "2_bedroom_avg_price"
        case threeBedroom = "3_bedroom_avg_price"
        case fourBedroom = "4_bedroom_avg_price"
        case fiveBedroom = "5_and_up_bedroom_avg_price"
    }
    
    let singleFamily: Int
    let condo: Int
    let bedrooms: [Int]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        singleFamily = try container.decode(Int.self, forKey: .singleFamily)
        condo = try container.decode(Int.self, forKey: .condo)
        let one = try container.decode(Int.self, forKey: .oneBedroom)
        let two = try container.decode(Int.self, forKey: .twoBedroom)
        let three = try container.decode(Int.self, forKey: .threeBedroom)
        let four = try container.decode(Int.self, forKey: .fourBedroom)
        let five = try container.decode(Int.self, forKey: .fiveBedroom)
        bedrooms = [one, two, three, four, five]
    }
}

/// four properties in the DS api's get_data endpoint are for weather conditions
/// this data structure combines them into a format that is easily used in displaying the data in WeatherVC
struct Conditions: Decodable {
    var labels = ["Sunny", "Cloudy", "Rainy", "Snowy"]
    var conditions: [Int]
}
