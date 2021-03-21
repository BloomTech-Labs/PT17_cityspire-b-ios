//
//  FavAnnotation.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

class FavAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var cityName: String

    init(coordinate: CLLocationCoordinate2D, cityName: String) {
        self.coordinate = coordinate
        self.cityName = cityName
    }
}

class FavDetailView: UIView {
    
    // MARK: - Properties
    
    var fav: FavAnnotation? {
        didSet {
            updateSubviews()
        }
    }
    
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func updateSubviews() {
        guard let fav = fav else { return }
        nameLabel.text = fav.cityName
    }
}
