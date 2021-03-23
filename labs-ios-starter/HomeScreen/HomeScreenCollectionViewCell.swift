//
//  HomeScreenCollectionViewCell.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/22/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var cityLabel: UILabel!
    
    // MARK: - Properties
    
    var city: Recommendation? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        guard let city = city else { return }
        cityLabel.text = city.city + ",\n" + city.state
    }
    
}
