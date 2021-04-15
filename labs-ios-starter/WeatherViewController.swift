//
//  WeatherViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 4/14/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var lowTempView: UIView!
    @IBOutlet private var highTempView: UIView!
    
    // MARK: - Properties
    
    var city: City?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    private func noWeatherDataAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "No weather data is available for this city.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }

}
