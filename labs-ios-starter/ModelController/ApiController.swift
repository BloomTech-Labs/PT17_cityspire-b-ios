//
//  ApiController.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

/// initialized in HomeScreenVC, and passed by segue to other VCs as needed
/// includes a cache to store city data as it is fetched to improve performance and reduce unnecessary network calls
/// includes a dataLoader to allow switching between mock data and URLSession
/// currently configured to use mock data, as no endpoints are available as of this writing
class ApiController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://notTheRealURL.herokuapp.com/api")! // needs editing!!!
    let dataLoader: NetworkDataLoader
    private let cache = Cache<String, City>()

//    init(dataLoader: NetworkDataLoader = URLSession.shared) { // replace next line with this when api is available
    init(dataLoader: NetworkDataLoader = MockLoader(data: validSFJSON)) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - Functions
    
    /// used to fetch city data, first checking if the city is already in the cache, and performing a network call if needed
    /// - Parameters:
    ///   - city: accepts an instance of City, usually containing only the name of city and state, and the coordinates
    ///   - completion: returns an updated instance of City with all available city data
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
    
    /// fetches a list of the top cities, to be displayed on HomeScreenVC
    /// needs editing once the endpoint is available, currently configured to use mock data
    /// - Parameter completion: returns an array of top cities as [Recommendation]
    func fetchTopCities(completion: @escaping ([Recommendation]) -> Void) {
        let path = "top_cities" // edit path when endpoint is available
        guard let request = getRequest(url: baseURL, urlPathComponent: path) else {
            completion([])
            return
        }
        dataLoader.dataRequest(with: request) { data, response, error in
            self.checkResponse(for: "fetchTopCities", data, response, error) { result in
                switch result {
                case .success(_): // replace _ with let data when data is available
                    do { // replace topCitiesData with data once endpoint is available
                        let cities = try JSONDecoder().decode(TopCities.self, from: topCitiesData)
                        completion(cities.top_cities)
                    } catch {
                        NSLog("Error decoding top cities data: \(error)")
                        completion([])
                    }
                default:
                    completion([])
                }
            }
        }
    }
    
    /// called in getPropertyData in CityDashboardVC to interpret string values into integers for use in configuring the CircularProgressBarView
    /// needs editing once the list of predetermined words is available from DS/Web
    /// - Parameter word: accepts a string from a predetermined list
    /// - Returns: returns an integer interpreting the string into a value between 0 and 100
    func stringToInt(word: String) -> Int {
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
    
    /// performs a network request to fetch city data
    /// needs updating once endpoint is available, currently configured to use mock data
    /// - Parameters:
    ///   - city: accepts an instance of City, usually containing only the name of city and state, and the coordinates
    ///   - completion: returns the updated City if request was successful, otherwise returns the original City
    private func getData(city: City, completion: @escaping (City) -> Void) {
        let path = "\(city.cityName)/\(city.cityState)" // edit path when endpoint is available
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
