//
//  MockData.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

let validSFJSON = """
{
  "city": {
    "city": "San Francisco",
    "state": "CA"
  },
  "latitude": 37.773972,
  "longitude": -122.431297,
  "rental_price": 3700,
  "crime": "High",
  "air_quality_index": "Good",
  "population": 886007,
  "diversity_index": 69,
  "sunny_days_avg_year": 80,
  "cloudy_days_avg_year": 236,
  "rainy_days_avg_year": 49,
  "snowy_days_avg_year": 0,
  "walkability": 87,
  "livability": 50,
  "recommendations": [
    {
      "city": "Odessa",
      "state": "TX"
    },
    {
      "city": "Provo",
      "state": "UT"
    },
    {
      "city": "Sanford",
      "state": "FL"
    },
    {
      "city": "Santa Clara",
      "state": "CA"
    },
    {
      "city": "Sheridan",
      "state": "WY"
    }
  ]
}
""".data(using: .utf8)!

let topCitiesData = """
{
  "top_cities": [
    {
      "city": "San Francisco",
      "state": "CA",
      "latitude": 37.758840565722686,
      "longitude": -122.44588851928711
    },
    {
      "city": "Seattle",
      "state": "WA",
      "latitude": 47.598457541981766,
      "longitude": -122.28600702714175
    },
    {
      "city": "Portland",
      "state": "OR",
      "latitude": 45.54294095464973,
      "longitude": -122.65438546892256
    },
    {
      "city": "Austin",
      "state": "TX",
      "latitude": 30.30799450600118,
      "longitude": -97.74993596132845
    },
    {
      "city": "New York",
      "state": "NY",
      "latitude": 40.70728095173828,
      "longitude": -74.02256537228823
    },
    {
      "city": "Boston",
      "state": "MA",
      "latitude": 42.3243932353924,
      "longitude": -71.01447454188019
    }
  ]
}
""".data(using: .utf8)!
