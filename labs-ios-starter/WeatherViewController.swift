//
//  WeatherViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 4/14/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import SceneKit

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var lowView: SCNView!
    @IBOutlet private var highView: SCNView!
    
    // MARK: - Properties
    
    var city: City?
    var lowScene = SCNScene()
    var lowCameraNode = SCNNode()
    var highScene = SCNScene()
    var highCameraNode = SCNNode()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCamera()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        guard let city = city,
              let weather = city.weather else { return }
        cityLabel.text = city.cityName + ", " + city.cityState
        drawBars(weather: weather)
    }
    
    private func drawBars(weather: Weather) {
        for index in 0..<weather.months.count {
            let lowHeight = CGFloat(weather.months[index].minTemp / 10)
            let lowYAdjust = lowHeight / 2
            let highHeight = CGFloat(weather.months[index].maxTemp / 12)
            let highYAdjust = highHeight / 2
            let position = (CGFloat(index) - 6)
            
            let lowBar = SCNBox(width: 1, height: lowHeight, length: 1.5, chamferRadius: 0.1)
            lowBar.materials.first?.diffuse.contents = UIColor(named: "LightBlue")
            let lowNode = SCNNode(geometry: lowBar)
            lowNode.position = SCNVector3(position, (lowYAdjust), 0)
            lowScene.rootNode.addChildNode(lowNode)
            
            let lowTemp = String(Int(weather.months[index].minTemp))
            let lowText = SCNText(string: lowTemp, extrusionDepth: 0)
            lowText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            lowText.materials.first?.diffuse.contents = UIColor(named: "OffWhite")
            let lowTextNode = SCNNode(geometry: lowText)
            lowTextNode.position = SCNVector3(-0.35, lowYAdjust - 2, 0.8)
            lowNode.addChildNode(lowTextNode)
            
            let highBar = SCNBox(width: 1, height: highHeight, length: 1.5, chamferRadius: 0.1)
            highBar.materials.first?.diffuse.contents = UIColor(named: "AccentYellow")
            let highNode = SCNNode(geometry: highBar)
            highNode.position = SCNVector3(position, (highYAdjust), 0)
            highScene.rootNode.addChildNode(highNode)
            
            let highTemp = String(Int(weather.months[index].maxTemp))
            let highText = SCNText(string: highTemp, extrusionDepth: 0)
            highText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            highText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let highTextNode = SCNNode(geometry: highText)
            highTextNode.position = SCNVector3(-0.35, lowYAdjust - 2, 0.8)
            highNode.addChildNode(highTextNode)
            
            guard let monthString = weather.months[index].month else { return }
            
            let lowMonthText = SCNText(string: monthString, extrusionDepth: 0)
            lowMonthText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            lowMonthText.materials.first?.diffuse.contents = UIColor(named: "OffWhite")
            let lowMonthNode = SCNNode(geometry: lowMonthText)
            lowMonthNode.position = SCNVector3(1, -lowYAdjust, 0.8)
            lowMonthNode.rotation = SCNVector4(0, 0, 1, 1.25)
            lowNode.addChildNode(lowMonthNode)
            
            let highMonthText = SCNText(string: monthString, extrusionDepth: 0)
            highMonthText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            highMonthText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let highMonthNode = SCNNode(geometry: highMonthText)
            highMonthNode.position = SCNVector3(1, -highYAdjust, 0.8)
            highMonthNode.rotation = SCNVector4(0, 0, 1, 1.25)
            highNode.addChildNode(highMonthNode)
        }
    }
    
    private func setupView() {
        lowView.allowsCameraControl = false
        lowView.autoenablesDefaultLighting = true
        highView.allowsCameraControl = false
        highView.autoenablesDefaultLighting = true
        lowView.scene = lowScene
        lowScene.background.contents = UIColor(named: "VeryLightBlue")
        highView.scene = highScene
        highScene.background.contents = UIColor(named: "VeryLightBlue")
    }
    
    private func setupCamera() {
        lowCameraNode.camera = SCNCamera()
        lowCameraNode.position = SCNVector3(x: -3, y: 8, z: 8)
        lowCameraNode.eulerAngles = SCNVector3(-0.4, -0.2, 0)
        lowScene.rootNode.addChildNode(lowCameraNode)
        highCameraNode.camera = SCNCamera()
        highCameraNode.position = SCNVector3(x: -3, y: 8, z: 8)
        highCameraNode.eulerAngles = SCNVector3(-0.4, -0.2, 0)
        highScene.rootNode.addChildNode(highCameraNode)
    }

}
