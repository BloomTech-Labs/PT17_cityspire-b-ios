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
class ApiController {
    
    // MARK: - Properties
    
    private let webBaseURL = URL(string: "https://pt17-cityspire-b.herokuapp.com/")!
    private let dsBaseURL = URL(string: "http://cityspire-b-ds.eba-jesgmne9.us-east-1.elasticbeanstalk.com/api")!
    let dataLoader: NetworkDataLoader
    private let cache = Cache<String, City>()

    init(dataLoader: NetworkDataLoader = URLSession.shared) {
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
        let mockDataLoader = MockLoader(data: topCitiesData)
        let path = "top_cities" // edit path when endpoint is available
        guard let request = getRequest(url: webBaseURL, urlPathComponent: path) else {
            completion([])
            return
        }
        mockDataLoader.dataRequest(with: request) { data, response, error in
            self.checkResponse(for: "fetchTopCities", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let cities = try JSONDecoder().decode(TopCities.self, from: data)
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
    /// Note: airQualityDictionary in Constants is used when saving the City to convert Air Quality Index words to the words used in this app
    /// - Parameter word: accepts a string from a predetermined list
    /// - Returns: returns an integer interpreting the string into a value between 0 and 100
    func stringToInt(word: String) -> Int {
        switch word {
        case "Hazardous":
            return 5
        case "Poor", "Low":
            return 30
        case "Fair":
            return 50
        case "Medium":
            return 60
        case "Good":
            return 75
        case "Excellent", "High":
            return 90
        default:
            return 0
        }
    }
    
    /// called in CityDashboard when the user selects Weather from the action sheet
    /// checks if Weather has already been saved in the cached City, and makes network request if needed
    /// - Parameters:
    ///   - city: accepts a City
    ///   - completion: upon success, saves Weather to the cached City, and returns Weather
    func fetchWeather(city: City, completion: @escaping (Weather?) -> Void) {
        let fullCityName = city.cityName + ", " + city.cityState
        if let cachedCity = cache.value(for: fullCityName),
           cachedCity.weather != nil {
            completion(cachedCity.weather)
            return
        }
        let path = "weather_monthly_forecast"
        guard let request = postRequestWithCity(url: dsBaseURL, urlPathComponent: path, city: city) else {
            completion(nil)
            return
        }
        dataLoader.dataRequest(with: request) { data, response, error in
            self.checkResponse(for: "fetchWeather", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let weather = try JSONDecoder().decode(Weather.self, from: data)
                        if weather.months.count == 0 {
                            completion(nil)
                        } else {
                            let fullCityName = city.cityName + ", " + city.cityState
                            if var cachedCity = self.cache.value(for: fullCityName) {
                                cachedCity.weather = weather
                                self.updateCachedCity(city: cachedCity)
                            }
                            completion(weather)
                        }
                    } catch {
                        NSLog("Error decoding weather data: \(error)")
                        completion(nil)
                    }
                default:
                    completion(nil)
                }
            }
        }
    }
    
    /// called in CityDashboard when the user selects Housing Prices from the action sheet
    /// checks if Housing has already been saved in the cached City, and makes network request if needed
    /// - Parameters:
    ///   - city: accepts a City
    ///   - completion: upon success, saves Housing to the cached City, and returns Housing
    func fetchHousing(city: City, completion: @escaping (Housing?) -> Void) {
        let fullCityName = city.cityName + ", " + city.cityState
        if let cachedCity = cache.value(for: fullCityName),
           cachedCity.housing != nil {
            completion(cachedCity.housing)
            return
        }
        let path = "housing_price_averages"
        guard let request = postRequestWithCity(url: dsBaseURL, urlPathComponent: path, city: city) else {
            completion(nil)
            return
        }
        dataLoader.dataRequest(with: request) { data, response, error in
            self.checkResponse(for: "fetchHousing", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let housing = try JSONDecoder().decode(Housing.self, from: data)
                        let fullCityName = city.cityName + ", " + city.cityState
                        if var cachedCity = self.cache.value(for: fullCityName) {
                            cachedCity.housing = housing
                            self.updateCachedCity(city: cachedCity)
                        }
                        completion(housing)
                    } catch {
                        NSLog("Error decoding housing data: \(error)")
                        completion(nil)
                    }
                default:
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    /// performs a network request to fetch city data
    /// if city data is unavailable in the data science api, calls getWalkability (the only property currently available for all cities nationwide)
    /// - Parameters:
    ///   - city: accepts an instance of City, usually containing only the name of city and state, and possibly coordinates
    ///   - completion: returns the updated City if request was successful, otherwise returns the original City
    private func getData(city: City, completion: @escaping (City) -> Void) {
        let path = "get_data"
        guard let request = postRequestWithCity(url: dsBaseURL, urlPathComponent: path, city: city) else {
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
                        completion(newCityData)
                    } catch {
                        NSLog("Error decoding city data: \(error)")
                        completion(city)
                    }
                default:
                    self.getWalkability(city: city) { city in
                        completion(city)
                    }
                }
            }
        }
    }
    
    /// updates a city in the cache
    /// - Parameter city: accepts a City
    private func updateCachedCity(city: City) {
        let fullCityName = city.cityName + ", " + city.cityState
        self.cache.cache(value: city, for: fullCityName)
    }
    
    /// performs a network request to fetch the walkability score for a city
    /// called in getData when the city is not found in the data science api
    /// - Parameters:
    ///   - city: accepts an instance of City, usually only containing the name of city and state, and possibly coordinates
    ///   - completion: returns the updated City if request was successful, otherwise returns the original City
    private func getWalkability(city: City, completion: @escaping (City) -> Void) {
        let path = "walkability"
        guard let request = postRequestWithCity(url: dsBaseURL, urlPathComponent: path, city: city) else {
            completion(city)
            return
        }
        dataLoader.dataRequest(with: request) { data, response, error in
            self.checkResponse(for: "getWalkability", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let walkability = try JSONDecoder().decode(Walkability.self, from: data)
                        var newCity = city
                        newCity.walkability = walkability.walkability
                        completion(newCity)
                    } catch {
                        NSLog("Error decoding walkability: \(error)")
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
    /// - Returns: returns a get request after applying the path component and JSON extension
    private func getRequest(url: URL, urlPathComponent: String?) -> URLRequest? {
        var urlPath = url
        if let path = urlPathComponent {
            urlPath = url.appendingPathComponent(path)
        }
        var request = URLRequest(url: urlPath)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
    
    /// sets up a post request using a url, urlPathComponent, and City to fetch data from the data science api
    /// - Parameters:
    ///   - url: accepts a url
    ///   - urlPathComponent: accepts a urlPathComponent
    ///   - city: accepts an instance of City, usually only containing the name of city and state, and possibly coordinates
    /// - Returns: returns a configured post request
    private func postRequestWithCity(url: URL, urlPathComponent: String, city: City) -> URLRequest? {
        let urlPath = url.appendingPathComponent(urlPathComponent)
        var request = URLRequest(url: urlPath)
        request.httpMethod = HTTPMethod.post.rawValue
        let parameters = PostCity(city: city.cityName, state: city.cityState)
        guard let jsonData = try? JSONEncoder().encode(parameters) else { return nil }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
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
