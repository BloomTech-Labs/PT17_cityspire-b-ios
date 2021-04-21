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
    @IBOutlet private var conditionsView: SCNView!
    @IBOutlet private var lowView: SCNView!
    @IBOutlet private var highView: SCNView!
    
    // MARK: - Properties
    
    var city: City?
    var lowScene = SCNScene()
    var lowCameraNode = SCNNode()
    var highScene = SCNScene()
    var highCameraNode = SCNNode()
    var conditionsScene = SCNScene()
    var conditionsCameraNode = SCNNode()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCameras()
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
        drawTemperatureBars(weather: weather)
        guard let conditions = city.conditions else { return }
        drawConditionsBars(conditions: conditions)
    }
    
    /// draws the bar graph for weather conditions
    /// - Parameter conditions: accepts an unwrapped version of the City's conditions
    private func drawConditionsBars(conditions: Conditions) {
        for index in 0..<conditions.conditions.count {
            let height = CGFloat(conditions.conditions[index]) / 35
            let yAdjust = height / 2
            let position = ((CGFloat(index) * 3) - 6)
            
            let bar = SCNBox(width: 3, height: height, length: 1.5, chamferRadius: 0.1)
            bar.materials.first?.diffuse.contents = UIColor(named: "PieChartPurple")
            let node = SCNNode(geometry: bar)
            node.position = SCNVector3(position, yAdjust + 0.5, 0)
            conditionsScene.rootNode.addChildNode(node)
            
            var daysHeightAdjust = CGFloat(-1.6)
            if conditions.conditions[index] < 25 {
                daysHeightAdjust = 0.5
            }
            let daysString = String(conditions.conditions[index])
            let daysText = SCNText(string: daysString, extrusionDepth: 0)
            daysText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.7)
            daysText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let daysTextNode = SCNNode(geometry: daysText)
            daysTextNode.position = SCNVector3(-0.6, yAdjust + daysHeightAdjust, 0.8)
            node.addChildNode(daysTextNode)
            
            let labelString = conditions.labels[index]
            let labelText = SCNText(string: labelString, extrusionDepth: 0)
            labelText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            labelText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let labelNode = SCNNode(geometry: labelText)
            labelNode.position = SCNVector3(-0.9, -yAdjust - 1.5, 0.8)
            node.addChildNode(labelNode)
        }
    }
    
    /// draws the bar graphs for average low temperatures and average high temperatures
    /// - Parameter weather: accepts an unwrapped version of the City's weather data
    private func drawTemperatureBars(weather: Weather) {
        for index in 0..<weather.months.count {
            let lowHeight = CGFloat(weather.months[index].minTemp / 10)
            let lowYAdjust = lowHeight / 2
            let highHeight = CGFloat(weather.months[index].maxTemp / 12)
            let highYAdjust = highHeight / 2
            let position = (CGFloat(index) - 6)
            
            let lowBar = SCNBox(width: 1, height: lowHeight, length: 1.5, chamferRadius: 0.1)
            lowBar.materials.first?.diffuse.contents = UIColor(named: "PieChartBlue")
            let lowNode = SCNNode(geometry: lowBar)
            lowNode.position = SCNVector3(position, lowYAdjust, 0)
            lowScene.rootNode.addChildNode(lowNode)
            
            let lowTemp = String(Int(weather.months[index].minTemp))
            let lowText = SCNText(string: lowTemp, extrusionDepth: 0)
            lowText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            lowText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let lowTextNode = SCNNode(geometry: lowText)
            lowTextNode.position = SCNVector3(-0.35, lowYAdjust - 1.6, 0.8)
            lowNode.addChildNode(lowTextNode)
            
            let highBar = SCNBox(width: 1, height: highHeight, length: 1.5, chamferRadius: 0.1)
            highBar.materials.first?.diffuse.contents = UIColor(named: "PieChartYellow")
            let highNode = SCNNode(geometry: highBar)
            highNode.position = SCNVector3(position, (highYAdjust), 0)
            highScene.rootNode.addChildNode(highNode)
            
            let highTemp = String(Int(weather.months[index].maxTemp))
            let highText = SCNText(string: highTemp, extrusionDepth: 0)
            highText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            highText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let highTextNode = SCNNode(geometry: highText)
            highTextNode.position = SCNVector3(-0.35, highYAdjust - 1.6, 0.8)
            highNode.addChildNode(highTextNode)
            
            guard let monthString = weather.months[index].month else { return }
            
            let lowMonthText = SCNText(string: monthString, extrusionDepth: 0)
            lowMonthText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            lowMonthText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
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
    
    /// configures each SceneKit view, and attaches the scene to the view
    private func setupViews() {
        lowView.allowsCameraControl = false
        lowView.autoenablesDefaultLighting = true
        highView.allowsCameraControl = false
        highView.autoenablesDefaultLighting = true
        conditionsView.allowsCameraControl = false
        conditionsView.autoenablesDefaultLighting = true
        
        lowView.scene = lowScene
        lowScene.background.contents = UIColor(named: "VeryLightBlue")
        highView.scene = highScene
        highScene.background.contents = UIColor(named: "VeryLightBlue")
        conditionsView.scene = conditionsScene
        conditionsScene.background.contents = UIColor(named: "VeryLightBlue")
    }
    
    /// sets up the camera for each SceneKit view, configuring its position and rotation angle
    private func setupCameras() {
        lowCameraNode.camera = SCNCamera()
        lowCameraNode.position = SCNVector3(x: -3, y: 8, z: 8)
        lowCameraNode.eulerAngles = SCNVector3(-0.4, -0.2, 0)
        lowScene.rootNode.addChildNode(lowCameraNode)
        
        highCameraNode.camera = SCNCamera()
        highCameraNode.position = SCNVector3(x: -3, y: 8, z: 8)
        highCameraNode.eulerAngles = SCNVector3(-0.4, -0.2, 0)
        highScene.rootNode.addChildNode(highCameraNode)
        
        conditionsCameraNode.camera = SCNCamera()
        conditionsCameraNode.position = SCNVector3(x: -3, y: 8, z: 8)
        conditionsCameraNode.eulerAngles = SCNVector3(-0.4, -0.2, 0)
        conditionsScene.rootNode.addChildNode(conditionsCameraNode)
    }

}
