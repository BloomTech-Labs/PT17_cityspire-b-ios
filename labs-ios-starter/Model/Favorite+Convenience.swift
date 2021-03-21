//
//  Favorite+Convenience.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData

extension Favorite {
    @discardableResult convenience init(cityName: String,
                                        stateName: String,
                                        latitude: Double,
                                        longitude: Double,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.cityName = cityName
        self.stateName = stateName
        self.latitude = latitude
        self.longitude = longitude
    }
}
