//
//  CityDashboardViewController.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityDashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var cityDashboardCollectionView: UICollectionView!
    @IBOutlet weak var pinToProfileButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    // MARK: - Properties
    var city: City?
    var similarCities: [City] = []
    var cityProperties: [String] = ["Livability", "Walkability", "Crime", "Air Quality", "Traffic", "Rental Price"]
    var cityDummyData: [Float] = [0.75, 0.4, 0.2, 0.5, 1, 0.35]
    var controller: ApiController?
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinToProfileButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapButton.layer.cornerRadius = 12
        pinToProfileButton.layer.cornerRadius = 12
        cityDashboardCollectionView.delegate = self
        cityDashboardCollectionView.dataSource = self
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK - Methods
    private func updateViews() {
        guard let city = city else { return }
        cityNameLabel.text = city.cityName + ", " + city.cityState
        populationLabel.text = "Population: 1,117,000"
//        populationLabel.text = "\(city.population)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityProperties.count
    }
    
    // TODO: Populate cells with properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityDashboardCell", for: indexPath) as! CityDashboardCollectionViewCell
        
        let cityProperty = cityProperties[indexPath.item]
        cell.cityPropertyNameLabel.text = "\(cityProperty)"
        let cityPropertyValue = cityDummyData[indexPath.item]
        cell.propertyValueLabel.text = "\(cityPropertyValue)"
        cell.progressBarView.setTrackedProgressWithAnimation(duration: 1.0, value: cityPropertyValue)
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            let mapVC = segue.destination as! MapViewController
            mapVC.city = city
        }
    }

}
