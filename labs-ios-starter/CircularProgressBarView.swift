//
//  CircularProgressBarView.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CircularProgressBarView: UIView {
    
    fileprivate var untrackedProgressLayer = CAShapeLayer()
    fileprivate var trackedProgressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }

    var untrackedProgressColor = UIColor.gray {
        didSet {
            untrackedProgressLayer.strokeColor = untrackedProgressColor.cgColor
        }
    }

    var trackedProgressColor = UIColor.blue {
        didSet {
            trackedProgressLayer.strokeColor = trackedProgressColor.cgColor
        }
    }
    
    /// Creates a clear circle that will be the path for the stroke of the animation.
    /// Untracked progress will be represented by a set color showing the user the trail of the progress bar
    /// Tracked progress will be represented by the animation color.
    func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: (frame.size.width - 1.5) / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)

        untrackedProgressLayer.path = circlePath.cgPath
        untrackedProgressLayer.fillColor = UIColor.clear.cgColor
        untrackedProgressLayer.strokeColor = UIColor(named: "PalestBlue")?.cgColor
        untrackedProgressLayer.lineWidth = 20.0
        untrackedProgressLayer.strokeEnd = 1.0
        layer.addSublayer(untrackedProgressLayer)
        
        trackedProgressLayer.path = circlePath.cgPath
        trackedProgressLayer.fillColor = UIColor.clear.cgColor
        trackedProgressLayer.strokeColor = trackedProgressColor.cgColor
        trackedProgressLayer.lineCap = .round
        trackedProgressLayer.lineWidth = 20.0
        trackedProgressLayer.strokeEnd = 1.0
        layer.addSublayer(trackedProgressLayer)
    }
    
    /// Takes a duration and value parameters to find the start of the stroke and animated the tracked progress color to the given value.
    /// - Parameters:
    ///   - duration: Accepts a double value that will set the number of seconds for animation
    ///   - value: Accepts a float value that will be the end point for the animation
    func setTrackedProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        trackedProgressLayer.strokeColor = UIColor(named: "LightBlue")?.cgColor
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        trackedProgressLayer.strokeEnd = CGFloat(value)
        trackedProgressLayer.add(animation, forKey: "animateprogress")
    }

}
