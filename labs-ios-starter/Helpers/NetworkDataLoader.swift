//
//  NetworkDataLoader.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

/// a protocol used to help configure a mock data loader for use in unit tests, and to provide mock data in the absence of endpoints
/// used as an extension on URLSession as well as in the MockLoader
protocol NetworkDataLoader {
    func dataRequest(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}
