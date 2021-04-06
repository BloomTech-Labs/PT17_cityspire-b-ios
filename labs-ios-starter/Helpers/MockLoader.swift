//
//  MockLoader.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

/// used to provide mock data for unit tests and for display in the UI in the absence of endpoints
class MockLoader: NetworkDataLoader {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data) {
        self.data = data
    }
    
    /// simulates a network request by waiting one second before returning the data stored in the data variable of MockLoader
    /// - Parameters:
    ///   - request: accepts a network request, which is unused due to the simulation
    ///   - completion: returns data, response, and error as optionals to simulate the completion of a network request
    func dataRequest(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.response, self.error)
        }
    }
}
