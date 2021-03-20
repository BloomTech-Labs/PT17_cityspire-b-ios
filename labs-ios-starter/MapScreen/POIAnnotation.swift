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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [categoryLabel, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
