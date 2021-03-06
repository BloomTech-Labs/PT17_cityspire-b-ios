//
//  CityDashboardCollectionViewCell.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityDashboardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cityPropertyNameLabel: UILabel!
    @IBOutlet weak var propertyValueLabel: UILabel!
    @IBOutlet weak var progressBarView: CircularProgressBarView!
    @IBOutlet weak var propertyDescriptionTextView: UITextView!
    
    // MARK: - Properties
    
    var color: UIColor? {
        didSet {
            if let colorCG = color?.cgColor {
                progressBarView.trackedProgressColor = colorCG
            }
        }
    }
    
}
