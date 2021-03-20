//
//  POICategory.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

class POICategory {
    let category: MKPointOfInterestCategory
    let plural: String
    let singular: String
    
    init(category: MKPointOfInterestCategory, plural: String, singular: String) {
        self.category = category
        self.plural = plural
        self.singular = singular
    }
}

class CategoryList {
    var cats: [POICategory] = [
        POICategory(category: .airport, plural: "Airports", singular: "Airport"),
        POICategory(category: .amusementPark, plural: "Amusement Parks", singular: "Amusement Park"),
        POICategory(category: .aquarium, plural: "Aquariums", singular: "Aquarium"),
        POICategory(category: .atm, plural: "ATMs", singular: "ATM"),
        POICategory(category: .bakery, plural: "Bakeries", singular: "Bakery"),
        POICategory(category: .bank, plural: "Banks", singular: "Bank"),
        POICategory(category: .beach, plural: "Beaches", singular: "Beach"),
        POICategory(category: .brewery, plural: "Breweries", singular: "Brewery"),
        POICategory(category: .cafe, plural: "Cafes", singular: "Cafe"),
        POICategory(category: .campground, plural: "Campgrounds", singular: "Campground"),
        POICategory(category: .carRental, plural: "Car Rentals", singular: "Car Rental"),
        POICategory(category: .evCharger, plural: "EV Chargers", singular: "EV Charger"),
        POICategory(category: .fireStation, plural: "Fire Stations", singular: "Fire Station"),
        POICategory(category: .fitnessCenter, plural: "Fitness Centers", singular: "Fitness Center"),
        POICategory(category: .foodMarket, plural: "Food Markets", singular: "Food Market"),
        POICategory(category: .gasStation, plural: "Gas Stations", singular: "Gas Station"),
        POICategory(category: .hospital, plural: "Hospitals", singular: "Hospital"),
        POICategory(category: .hotel, plural: "Hotels", singular: "Hotel"),
        POICategory(category: .laundry, plural: "Laundry", singular: "Laundry"),
        POICategory(category: .library, plural: "Libraries", singular: "Library"),
        POICategory(category: .marina, plural: "Marinas", singular: "Marina"),
        POICategory(category: .movieTheater, plural: "Movie Theaters", singular: "Movie Theater"),
        POICategory(category: .museum, plural: "Museums", singular: "Museum"),
        POICategory(category: .nationalPark, plural: "National Parks", singular: "National Park"),
        POICategory(category: .nightlife, plural: "Nightlife", singular: "Nightlife"),
        POICategory(category: .park, plural: "Parks", singular: "Park"),
        POICategory(category: .parking, plural: "Parking", singular: "Parking"),
        POICategory(category: .pharmacy, plural: "Pharmacies", singular: "Pharmacy"),
        POICategory(category: .police, plural: "Police", singular: "Police"),
        POICategory(category: .postOffice, plural: "Post Offices", singular: "Post Office"),
        POICategory(category: .publicTransport, plural: "Public Transport", singular: "Public Transport"),
        POICategory(category: .restaurant, plural: "Restaurants", singular: "Restaurant"),
        POICategory(category: .restroom, plural: "Restrooms", singular: "Restroom"),
        POICategory(category: .school, plural: "Schools", singular: "School"),
        POICategory(category: .stadium, plural: "Stadiums", singular: "Stadium"),
        POICategory(category: .store, plural: "Stores", singular: "Store"),
        POICategory(category: .theater, plural: "Theaters", singular: "Theater"),
        POICategory(category: .university, plural: "Universities", singular: "University"),
        POICategory(category: .winery, plural: "Wineries", singular: "Winery"),
        POICategory(category: .zoo, plural: "Zoos", singular: "Zoo")
    ]
}
