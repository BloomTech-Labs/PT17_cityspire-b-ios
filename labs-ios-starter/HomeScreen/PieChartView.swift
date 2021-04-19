//
//  PieChartView.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 4/16/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var segments = [PieChartSegment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let radius = min(frame.size.width, frame.size.height) / 2
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        
        // enumerate the total value of the segments by using reduce to sum them together
        let valueCount = segments.reduce(0, { $0 + $1.value })
        
        // The starting angle is -90 degrees (top of the circle, as the context is
        // flipped). By default, 0 is the right hand side of the circle, with the
        // positive angle being in an anti-clockwise direction (same as a unit
        // circle in maths).
        var startPoint = -CGFloat.pi * 0.5
        
        for segment in segments {
            context?.setFillColor(segment.color.cgColor)
            let endPoint = startPoint + 2 * .pi * (segment.value / valueCount)
            context?.move(to: center)
            // Add arc from the center for each segment (anticlockwise is specified
            // for the arc, but as the view flips the context, it will produce a
            // clockwise arc).
            context?.addArc(center: center, radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: false)
            context?.fillPath()
            startPoint = endPoint // updates the next start point as the previous endpoint
        }
    }
}
