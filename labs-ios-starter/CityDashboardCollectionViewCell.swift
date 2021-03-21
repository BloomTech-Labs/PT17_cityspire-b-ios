//
//  CityDashboardCollectionViewCell.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityDashboardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var cityPropertyNameLabel: UILabel!
    @IBOutlet weak var propertyValueLabel: UILabel!
    @IBOutlet weak var progressBarView: CircularProgressBarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateCircleProgressBarView()
    }
    
    private func updateCircleProgressBarView() {
        progressBarView.untrackedProgressColor = UIColor.gray
        progressBarView.setTrackedProgressWithAnimation(duration: 1.0, value: 0.7)
    }
}
