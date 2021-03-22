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
    
    private let baseURL = URL(string: "https://notTheRealURL.herokuapp.com/api")! // needs editing!!!
    let dataLoader: NetworkDataLoader
    private let cache = Cache<String, City>()

//    init(dataLoader: NetworkDataLoader = URLSession.shared) {
    init(dataLoader: NetworkDataLoader = MockLoader(data: validSFJSON)) {
        self.dataLoader = dataLoader
    }
    
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
    
    func stringToInt(word: String) -> Int { // edit once list is available from DS
        switch word {
        case "Poor", "Very Low":
            return 5
        case "Fair", "Low":
            return 30
        case "Good", "Medium":
            return 50
        case "Very Good", "High":
            return 75
        case "Excellent", "Very High":
            return 100
        default:
            return 0
        }
    }
    
    // MARK: - Private Functions
    
    private func getData(city: City, completion: @escaping (City) -> Void) {
        // edit networking code when endpoint is available
        let path = "\(city.cityName)/\(city.cityState)"
        guard let request = getRequest(url: baseURL, urlPathComponent: path) else {
            completion(city)
            return
        }
        dataLoader.dataRequest(with: request) { data, response, error in
            self.checkResponse(for: "getCityData", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        var newCityData = try JSONDecoder().decode(City.self, from: data)
                        newCityData.cityName = city.cityName
                        newCityData.cityState = city.cityState
                        newCityData.latitude = city.latitude
                        newCityData.longitude = city.longitude
                        completion(newCityData)
                    } catch {
                        NSLog("Error decoding city data: \(error)")
                        completion(city)
                    }
                default:
                    completion(city)
                }
            }
        }
    }
    
    /// Sets up a get request using a url and an optional urlPathComponent
    /// - Parameters:
    ///   - url: accepts a url
    ///   - urlPathComponent: optional String to add a urlPathComponent
    /// - Returns: returns a get request after applying the bearer token, path component, and JSON extension
    private func getRequest(url: URL, urlPathComponent: String?) -> URLRequest? {
        var urlPath = url
        if let path = urlPathComponent {
            urlPath = url.appendingPathComponent(path)
        }
        var request = URLRequest(url: urlPath)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
    
    /// a helper function that checks data, response, and error from a data task
    /// - Parameters:
    ///   - taskDescription: accepts a String containing the function name where the data task is called for printing responses
    ///   - data: pass in the data received from the data task
    ///   - response: pass in the response received from the data task
    ///   - error: pass in the error received from the data task
    ///   - completion: returns either success(data) or failure(NetworkError)
    private func checkResponse(for taskDescription: String, _ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let error = error {
            NSLog("\(taskDescription) failed with error: \(error)")
            completion(.failure(.otherError))
            return
        }
        if let response = response as? HTTPURLResponse,
           !(200...210 ~= response.statusCode) {
            NSLog("\(taskDescription) failed response - \(response)")
            completion(.failure(.failedResponse))
            return
        }
        guard let data = data,
              !data.isEmpty else {
            NSLog("Data was not received from \(taskDescription)")
            completion(.failure(.noData))
            return
        }
        completion(.success(data))
    }
    
}
