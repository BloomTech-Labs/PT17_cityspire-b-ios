//
//  MockLoader.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

class MockLoader: NetworkDataLoader {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data) {
        self.data = data
    }
    
    func dataRequest(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.response, self.error)
        }
    }
}
