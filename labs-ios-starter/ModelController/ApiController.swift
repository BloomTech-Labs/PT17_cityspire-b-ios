//
//  ApiController.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

class ApiController {
    
    // MARK: - Properties
    
    // private let baseURL = URL(string: "")!
    
    private let cache = Cache<String, City>()
    
    // MARK: - Functions
    
    func fetchCityData(city: City, completion: @escaping (City) -> Void) {
        let fullCityName = city.cityName + ", " + city.cityState
        if let cachedCity = cache.value(for: fullCityName),
           cachedCity.walkability != nil {
            completion(cachedCity)
            return
        }
        getData(city: city) { updatedCity in
            self.cache.cache(value: updatedCity, for: fullCityName)
            completion(updatedCity)
        }
    }
    
    // MARK: - Private Functions
    
    private func getData(city: City, completion: @escaping (City) -> Void) {
        completion(city) // add networking code when endpoint is available
    }
    
}
