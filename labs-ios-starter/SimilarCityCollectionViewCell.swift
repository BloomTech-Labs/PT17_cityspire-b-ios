//
//  SimilarCityCollectionViewCell.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/22/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class SimilarCityCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet private var background: UIView!
    
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
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor(named: "DarkishBlue")?.cgColor
    }
}
