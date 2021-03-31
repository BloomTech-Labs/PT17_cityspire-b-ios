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
    @IBOutlet private var imageView: UIImageView!
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
        imageView.image = UIImage(named: city.state)
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor(named: "DarkishBlue")?.cgColor
    }
    
}
