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
    private let background = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        background.backgroundColor = UIColor(named: "PaleBlue")
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor(named: "DarkBlue")
        nameLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        background.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10).isActive = true
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
