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
    var cityProperties: [String] = ["Livability", "Walkability", "Crime", "Air Quality", "Traffic", "Rental Price"]
    var cityDummyData: [Float] = [0.75, 0.4, 0.2, 0.5, 1, 0.35]
    var favorites: [Favorite] = []
    var favorited: Favorite? = nil
    var controller: ApiController?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // var cityProperties: [Int?] {
    //     let crime = controller?.stringToInt(word: city?.crime ?? "")
    //     let airQuality = controller?.stringToInt(word: city?.airQuality ?? "")
    //     return [city?.livability, city?.walkability, city?.traffic, airQuality, crime, city?.rentalPrice]
    // }

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
            // toggle appearance of pin button - not in favorites
        } else {
            let favorite = Favorite(cityName: cityName,
                                    stateName: stateName,
                                    latitude: latitude,
                                    longitude: longitude,
                                    context: context)
            favorited = favorite
            // toggle appearance of pin button - in favorites
        }
        do {
            try context.save()
        }
        catch {
            print("error saving data")
        }
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
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        do {
            self.favorites = try context.fetch(Favorite.fetchRequest())
            for favorite in favorites {
                if favorite.cityName == city?.cityName && favorite.stateName == city?.cityState {
                    favorited = favorite
                    // toggle appearance of pin button - in favorites
                }
            }
        }
        catch {
            print("error fetching data")
        }
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
