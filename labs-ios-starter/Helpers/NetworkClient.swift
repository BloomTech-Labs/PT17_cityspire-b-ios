//
//  NetworkClient.swift
//  labs-ios-starter
//
//  Created by Jarren Campos on 2/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

/// Handles logic for networking requests to retrieve specific information for a city
struct NetworkClient {
    // MARK: - Properties
    let api = "http://cityscape-203.eba-ijacxhm2.us-east-1.elasticbeanstalk.com/api/"
    
    /// Function to retrieve walkability score
    /// - Parameters:
    ///  - city: city to be entered to get specific score
    ///  - state: state to be entered to get specific score
    ///  - completion: Closure that will be called when the request is complete
    func getWalkability(city: String, state: String, completion: @escaping (Walkability?, Error?) -> ()) {
        
        let endpoint = "walkability"
        guard let url = URL(string: api + endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let body = PostParams(city: city, state: state)
        guard let jsonData = try? JSONEncoder().encode(body) else { return }
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let walkability = try JSONDecoder().decode(Walkability.self, from: data)
                    completion(walkability, nil)
                }
                catch {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }
}
