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
    
    var trackedProgressColor = UIColor.gray {
        didSet {
            trackedProgressLayer.strokeColor = trackedProgressColor.cgColor
        }
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2 // makes a circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: (frame.size.width - 1.5) / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackedProgressLayer.path = circlePath.cgPath
        trackedProgressLayer.fillColor = UIColor.clear.cgColor
        trackedProgressLayer.strokeColor = trackedProgressColor.cgColor
        trackedProgressLayer.lineWidth = 10.0
        trackedProgressLayer.strokeEnd = 1.0
        layer.addSublayer(trackedProgressLayer)
        
        untrackedProgressLayer.path = circlePath.cgPath
        untrackedProgressLayer.fillColor = UIColor.clear.cgColor
        untrackedProgressLayer.strokeColor = untrackedProgressColor.cgColor
        untrackedProgressLayer.lineWidth = 10.0
        untrackedProgressLayer.strokeEnd = 0.0
        layer.addSublayer(untrackedProgressLayer)
    }
    
    func setTrackedProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        trackedProgressLayer.strokeEnd = CGFloat(value)
        trackedProgressLayer.add(animation, forKey: "animateprogress")
    }

}
