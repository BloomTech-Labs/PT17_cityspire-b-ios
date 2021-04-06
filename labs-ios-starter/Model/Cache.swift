//
//  Cache.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

/// a generic cache class, used in this project to store City data to avoid unnecessary network calls
/// implemented in ApiController
class Cache<Key: Hashable, Value> {
    
    // MARK: - Properties
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.CitySpire.CacheQueue")
    
    // MARK: - Public Functions
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    func clear() {
        queue.async {
            self.cache.removeAll()
        }
    }
}
