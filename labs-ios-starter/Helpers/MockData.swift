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
  "latitude": 37.758840565722686,
  "longitude": -122.44588851928711,
  "rental_price": 2800,
  "crime": "Low",
  "air_quality_index": "Good",
  "population": 874961,
  "diversity_index": 80,
  "walkability": 88,
  "livability": 70,
  "recommendations": [
    {
      "city": "Seattle",
      "state": "WA"
    },
    {
      "city": "Portland",
      "state": "OR"
    },
    {
      "city": "Austin",
      "state": "TX"
    },
    {
      "city": "New York",
      "state": "NY"
    },
    {
      "city": "Boston",
      "state": "MA"
    }
  ]
}
""".data(using: .utf8)!
