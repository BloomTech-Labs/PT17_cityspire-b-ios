//
//  POIAnnotation.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var category: POICategory

    init(coordinate: CLLocationCoordinate2D, name: String?, category: POICategory) {
        self.coordinate = coordinate
        self.name = name ?? ""
        self.category = category
    }
}

class POIDetailView: UIView {
    
    // MARK: - Properties
    
    var poi: POIAnnotation? {
        didSet {
            updateSubviews()
        }
    }
    
    private let categoryLabel = UILabel()
    private let nameLabel = UILabel()
    private let background = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        background.backgroundColor = UIColor(named: "PaleBlue")
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        categoryLabel.textAlignment = .right
        categoryLabel.textColor = UIColor(named: "AccentGreen")
        categoryLabel.font = UIFont(name: "TrebuchetMS", size: 14)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor(named: "DarkBlue")
        nameLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        nameLabel.numberOfLines = 3
        
        let stackView = UIStackView(arrangedSubviews: [categoryLabel, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func updateSubviews() {
        guard let poi = poi else { return }
        categoryLabel.text = poi.category.singular
        nameLabel.text = poi.name
    }
}
