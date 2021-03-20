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
    @IBOutlet weak var progressBarView: UIView!
    
    // TODO: have to switch updateCircleProgressBarView and animateProgress into collection view cell
    private func updateCircleProgressBarView() {
        let circleProgressBar = CircularProgressBarView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
        circleProgressBar.trackedProgressColor = UIColor.blue
        circleProgressBar.untrackedProgressColor = UIColor.gray
        self.view.addSubview(circleProgressBar)
        circleProgressBar.center = self.view.center
        self.perform(#selector(animateProgress), with: nil, afterDelay: 1.0)
    }
    
    @objc func animateProgress() {
        let circleProgressBar = self.view.viewWithTag(101) as! CircularProgressBarView
        circleProgressBar.setTrackedProgressWithAnimation(duration: 1.0, value: 0.7)
    }
    
}
