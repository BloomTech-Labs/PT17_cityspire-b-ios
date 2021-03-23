//
//  HomeScreenViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/22/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class HomeScreenViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var pinButton: UIButton!
    @IBOutlet private var surveyButton: UIButton!
    
    // MARK: - Properties
    
    let controller = ApiController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var topCities: [Recommendation] = []
    var city = City(cityName: "", cityState: "")
    var cityName = ""
    var stateName = ""
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        updateViews()
    }
    
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        fetchFavoriteCount()
    }
    
    // MARK: - Actions
    
    @IBAction func surveyButtonPressed(_ sender: Any) {
        Alert.showBasicAlert(on: self, with: "New Feature Coming Soon!", message: "Soon you'll be able to answer a few questions and get a list of recommended cities.")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToCityDashboard" {
            let cityDashboardVC = segue.destination as! CityDashboardViewController
            cityDashboardVC.city = city
            cityDashboardVC.controller = controller
        }
        else if segue.identifier == "homeToFavorites" {
            let favoritesVC = segue.destination as! FavoritesViewController
            favoritesVC.controller = controller
        }
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        fetchFavoriteCount()
        fetchTopCities()
    }
    
    private func fetchFavoriteCount() {
        do {
            let favorites = try context.fetch(Favorite.fetchRequest())
            DispatchQueue.main.async {
                self.pinButton.setTitle("\(favorites.count)", for: .normal)
            }
        }
        catch {
            print("error fetching data")
        }
    }
    
    private func fetchTopCities() {
        controller.fetchTopCities { cities in
            DispatchQueue.main.async {
                self.topCities = cities
                self.collectionView.reloadData()
            }
        }
    }
    
    /// checks for correct format of search bar text, populates city, state, and searchResponse.cityName
    /// - Parameter text: accepts a string
    /// - Returns: returns true if valid format, otherwise false
    private func formatText(_ text: String?) -> Bool {
        cityName = ""
        stateName = ""
        guard var text = text else {
            return false
        }
        for char in text {
            if char == "," {
                text = text.replacingOccurrences(of: cityName, with: "")
                stateName = text.uppercased()
                stateName = stateName.replacingOccurrences(of: ",", with: "")
                stateName = stateName.replacingOccurrences(of: " ", with: "")
                break
            } else {
                cityName.append(char)
            }
        }
        cityName = cityName.capitalized
        if stateName.count != 2 || cityName.count < 2 {
            return false
        }
        city.cityName = cityName + ", " + stateName
        return true
    }
    
    /// called in searchBarSearchButtonClicked after successfully formatting text
    /// performs a search with MapKit, correcting city name spelling as needed
    /// presents user with alert to cofirm city, and upon confirmation, performs segue to city details
    private func conductSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = city.cityName
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            if response == nil || response?.mapItems.first?.pointOfInterestCategory != nil {
                Alert.showBasicAlert(on: self, with: "City Not Found", message: "Please try again.")
            } else {
                guard let cityName = response?.mapItems.first?.name else {
                    Alert.showBasicAlert(on: self, with: "City Not Found", message: "Please try again.")
                    return
                }
                let alert = UIAlertController(title: "View Details for\n\(cityName), \(self.stateName)?", message: nil, preferredStyle: .alert)
                let noButton = UIAlertAction(title: "Re-enter City", style: .default)
                let yesButton = UIAlertAction(title: "View City", style: .default) { _ in
                    self.cityName = cityName
                    self.city.cityName = cityName
                    self.city.cityState = self.stateName
                    self.city.longitude = (response?.boundingRegion.center.longitude)!
                    self.city.latitude = (response?.boundingRegion.center.latitude)!
                    self.controller.fetchCityData(city: self.city) { city in
                        self.city = city
                        self.performSegue(withIdentifier: "homeToCityDashboard", sender: self)
                    }
                }
                alert.addAction(noButton)
                alert.addAction(yesButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.homeScreenCell, for: indexPath) as! HomeScreenCollectionViewCell
        cell.city = topCities[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let city = topCities[indexPath.item]
        let cityName = city.city
        let stateName = city.state
        controller.fetchCityData(city: City(cityName: cityName, cityState: stateName), completion: { topCity in
            self.city = topCity
            if self.city.latitude == 0 || self.city.longitude == 0 {
                self.city.latitude = city.latitude
                self.city.longitude = city.longitude
            }
            self.performSegue(withIdentifier: "homeToCityDashboard", sender: self)
        })
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        guard formatText(text) else {
            Alert.showBasicAlert(on: self, with: "Please Enter a Valid City & State", message: "example: San Francisco, CA")
            return
        }
        conductSearch()
    }
}
