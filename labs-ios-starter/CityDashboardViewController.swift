//
//  CityDashboardViewController.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityDashboardViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var cityDashboardCollectionView: UICollectionView!
    @IBOutlet weak var pinToProfileButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    // MARK: - Properties
    
    var controller: ApiController?
    var city: City?
    var propertyData: [PropertyData] = []
    var favorites: [Favorite] = []
    var favorited: Favorite? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPropertyData()
        cityDashboardCollectionView.delegate = self
        cityDashboardCollectionView.dataSource = self
        updateViews()
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinToProfileButtonTapped(_ sender: UIButton) {
        guard let cityName = city?.cityName,
              let stateName = city?.cityState,
              let latitude = city?.latitude,
              let longitude = city?.longitude else { return }
        if let favorite = favorited {
            context.delete(favorite)
            favorited = nil
            pinToProfileButton.setImage(UIImage(systemName: "pin"), for: .normal)
        } else {
            let favorite = Favorite(cityName: cityName,
                                    stateName: stateName,
                                    latitude: latitude,
                                    longitude: longitude,
                                    context: context)
            favorited = favorite
            pinToProfileButton.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        }
        do {
            try context.save()
        }
        catch {
            print("error saving data")
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            let mapVC = segue.destination as! MapViewController
            mapVC.city = city
        }
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        guard let city = city else { return }
        cityNameLabel.text = city.cityName + ", " + city.cityState
        populationLabel.text = "Population: unknown"
        if let population = city.population {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if let popString = formatter.string(from: NSNumber(value: population)) {
                populationLabel.text = "Population: \(popString)"
            }
        }
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        do {
            self.favorites = try context.fetch(Favorite.fetchRequest())
            for favorite in favorites {
                if favorite.cityName == city?.cityName && favorite.stateName == city?.cityState {
                    favorited = favorite
                    pinToProfileButton.setImage(UIImage(systemName: "pin.fill"), for: .normal)
                }
            }
        }
        catch {
            print("error fetching data")
        }
    }
    
    private func getPropertyData() {
        guard let city = city else { return }
        
        // Livability
        if let livability = city.livability,
           livability != 0 {
            let property = PropertyData(propertyLabel: "Livability", valueLabel: "\(livability)", percentage: Float(livability) / 100)
            propertyData.append(property)
        }
        
        // Walkability
        if let walkability = city.walkability,
           walkability != 0 {
            let property = PropertyData(propertyLabel: "Walkability", valueLabel: "\(walkability)", percentage: Float(walkability) / 100)
            propertyData.append(property)
        }
        
        // Diversity Score
        if let diversity = city.diversityIndex,
           diversity != 0 {
            let property = PropertyData(propertyLabel: "Diversity Index", valueLabel: "\(diversity)", percentage: Float(diversity) / 100)
            propertyData.append(property)
        }
        
        // Crime
        if let crime = city.crime,
           let crimeScore = controller?.stringToInt(word: crime) {
            let property = PropertyData(propertyLabel: "Crime", valueLabel: "\(crime)", percentage: Float(crimeScore) / 100)
            propertyData.append(property)
        }
        
        // Air Quality
        if let airQuality = city.airQuality,
           let airScore = controller?.stringToInt(word: airQuality) {
            let property = PropertyData(propertyLabel: "Air Quality", valueLabel: "\(airQuality)", percentage: Float(airScore) / 100)
            propertyData.append(property)
        }
        
        // Rental Price
        if let rentalPrice = city.rentalPrice,
           rentalPrice != 0 {
            let property = PropertyData(propertyLabel: "Rental Price", valueLabel: "$\(rentalPrice)", percentage: Float(rentalPrice) / 3600)
            propertyData.append(property)
        }
    }
}

extension CityDashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return propertyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityDashboardCell", for: indexPath) as! CityDashboardCollectionViewCell
        cell.cityPropertyNameLabel.text = propertyData[indexPath.item].propertyLabel
        cell.propertyValueLabel.text = propertyData[indexPath.item].valueLabel
        cell.progressBarView.setTrackedProgressWithAnimation(duration: 1.0, value: propertyData[indexPath.item].percentage)
        return cell
    }
}
