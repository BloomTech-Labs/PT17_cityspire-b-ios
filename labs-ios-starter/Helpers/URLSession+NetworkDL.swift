//
//  URLSession+NetworkDL.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func dataRequest(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}
