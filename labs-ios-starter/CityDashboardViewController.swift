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
    @IBOutlet weak var similarCitiesCollectionView: UICollectionView!
    @IBOutlet weak var pinToProfileButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    
    // MARK: - Properties
    
    var controller: ApiController?
    var tabDelegate: TabButtonDelegate?
    var propertyData: [PropertyData] = []
    var favorites: [Favorite] = []
    var favorited: Favorite? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityStack: [City] = [] {
        didSet {
            currentCity = cityStack.last
        }
    }
    var currentCity: City? {
        didSet {
            if isViewLoaded {
                reloadView()
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPropertyData()
        cityDashboardCollectionView.delegate = self
        cityDashboardCollectionView.dataSource = self
        similarCitiesCollectionView.delegate = self
        similarCitiesCollectionView.dataSource = self
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if cityStack.count > 1 {
            var _ = cityStack.popLast()
        } else {
            backButton.isEnabled = false
            backButton.setTitleColor(.clear, for: .normal)
        }
    }
    
    @IBAction func pinToProfileButtonTapped(_ sender: UIButton) {
        guard let cityName = currentCity?.cityName,
              let stateName = currentCity?.cityState,
              let latitude = currentCity?.latitude,
              let longitude = currentCity?.longitude else { return }
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
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            self.tabDelegate?.homeSelected()
        }
    }
    
    @IBAction func pinButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            self.tabDelegate?.pinsSelected()
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            self.tabDelegate?.settingsSelected()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentCity = currentCity else { return }
        if segue.identifier == "MapSegue" {
            let mapVC = segue.destination as! MapViewController
            mapVC.city = currentCity
        }
    }
    
    // MARK: - Private Functions
    
    private func reloadView() {
        getPropertyData()
        updateViews()
        cityDashboardCollectionView.reloadData()
        similarCitiesCollectionView.reloadData()
    }
    
    private func updateViews() {
        guard let city = currentCity else { return }
        if cityStack.count == 1 {
            backButton.isEnabled = false
            backButton.setTitleColor(.clear, for: .normal)
        }
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
                if favorite.cityName == currentCity?.cityName && favorite.stateName == currentCity?.cityState {
                    favorited = favorite
                    pinToProfileButton.setImage(UIImage(systemName: "pin.fill"), for: .normal)
                }
            }
        }
        catch {
            print("error fetching data")
        }
    }
    
    /// Finds the city values of the current city selected in the city dashboard.
    /// Converts values Int or String to a float value to use as an endpoint in the circular progress bar.
    /// Appends the value to the property data array, which is used to populate the city property collection view cell.
    private func getPropertyData() {
        guard let city = currentCity else { return }
        propertyData = []
        
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
        if collectionView == self.cityDashboardCollectionView {
            return propertyData.count
        }
        if let city = currentCity {
            return city.recommendations.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cityDashboardCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityDashboardCell", for: indexPath) as! CityDashboardCollectionViewCell
            cell.cityPropertyNameLabel.text = propertyData[indexPath.item].propertyLabel
            cell.propertyValueLabel.text = propertyData[indexPath.item].valueLabel
            cell.progressBarView.setTrackedProgressWithAnimation(duration: 1.0, value: propertyData[indexPath.item].percentage)
            cell.layer.cornerRadius = 15
            cell.layer.borderColor = UIColor(named: "DarkishBlue")?.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
        
        if collectionView == self.similarCitiesCollectionView {
            if let city = currentCity?.recommendations[indexPath.item] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.homeScreenCell, for: indexPath) as! HomeScreenCollectionViewCell
                cell.city = city
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.similarCitiesCollectionView {
            guard let nextCity = currentCity?.recommendations[indexPath.item] else { return }
            let cityName = nextCity.city
            let stateName = nextCity.state
            controller?.fetchCityData(city: City(cityName: cityName, cityState: stateName), completion: { city in
                DispatchQueue.main.async {
                    self.cityStack.append(city)
                    self.backButton.isEnabled = true
                    self.backButton.setTitleColor(.systemBlue, for: .normal)
                }
            })
        }
    }
}
