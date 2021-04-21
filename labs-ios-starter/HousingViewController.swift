//
//  HousingViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 4/18/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import SceneKit

class HousingViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var singleFamilyLabel: UILabel!
    @IBOutlet private var condoLabel: UILabel!
    @IBOutlet private var sceneView: SCNView!
    
    // MARK: - Properties
    
    var city: City?
    let bedrooms = ["1", "2", "3", "4", "5+"]
    let formatter = NumberFormatter()
    var scene = SCNScene()
    var cameraNode = SCNNode()
    
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
              let housing = city.housing else { return }
        cityLabel.text = city.cityName + ", " + city.cityState
        
        formatter.numberStyle = .decimal
        if let singleFamilyString = formatter.string(from: NSNumber(value: housing.singleFamily)) {
            singleFamilyLabel.text = "$\(singleFamilyString)"
        }
        if let condoString = formatter.string(from: NSNumber(value: housing.condo)) {
            condoLabel.text = "$\(condoString)"
        }
        
        drawBars(housing: housing)
    }
    
    /// draws the bar graph for housing prices by bedroom
    /// - Parameter housing: accepts an unwrapped version of the City's housing data
    private func drawBars(housing: Housing) {
        guard housing.bedrooms.count == 5 else { return }
        let maxPrice = CGFloat(housing.bedrooms[4])
        for index in 0..<housing.bedrooms.count {
            let ratio = CGFloat(housing.bedrooms[index]) / maxPrice
            let height = 1.5 + (ratio * 6)
            let yAdjust = height / 2
            let position = ((CGFloat(index) * 2) - 5)
            
            let bar = SCNBox(width: 2, height: height, length: 1.5, chamferRadius: 0.1)
            bar.materials.first?.diffuse.contents = UIColor(named: "PieChartGreen")
            let node = SCNNode(geometry: bar)
            node.position = SCNVector3(position, yAdjust, 0)
            scene.rootNode.addChildNode(node)
            
            let priceAdjust = Int(housing.bedrooms[index] / 1000)
            guard let price = formatter.string(from: NSNumber(value: priceAdjust)) else { return }
            let priceString = "$\(price)K"
            let priceText = SCNText(string: priceString, extrusionDepth: 0)
            priceText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.5)
            priceText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let priceTextNode = SCNNode(geometry: priceText)
            priceTextNode.position = SCNVector3(-1.5, yAdjust - 1, 0.8)
            priceTextNode.rotation = SCNVector4(0, 0, 1, -0.75)
            node.addChildNode(priceTextNode)
            
            let bedroomString = "\(bedrooms[index])"
            let bedroomText = SCNText(string: bedroomString, extrusionDepth: 0)
            bedroomText.font = UIFont(name: "TrebuchetMS-Bold", size: 0.6)
            bedroomText.materials.first?.diffuse.contents = UIColor(named: "DarkBlue")
            let bedroomNode = SCNNode(geometry: bedroomText)
            bedroomNode.position = SCNVector3(-0.3, -yAdjust, 0.8)
            node.addChildNode(bedroomNode)
        }
    }
    
    /// configures the SceneKit view, and attaches the scene to the view
    private func setupView() {
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
        scene.background.contents = UIColor(named: "VeryLightBlue")
    }
    
    /// sets up the camera for the SceneKit view, configuring its position and rotation angle
    private func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: -3, y: 8, z: 8)
        cameraNode.eulerAngles = SCNVector3(-0.4, -0.2, 0)
        scene.rootNode.addChildNode(cameraNode)
    }

}
