//
//  SearchViewController.swift
//  labs-ios-starter
//
//  Created by Jarren Campos on 1/27/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var city = City(cityName: "", cityState: "")
    var network = NetworkClient()
    var cityName = ""
    var stateName = ""
    let controller = ApiController()
    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundGradient: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCityDashboard" {
            let cityDashboardVC = segue.destination as! CityDashboardViewController
            cityDashboardVC.city = city
            cityDashboardVC.controller = controller
//            let vc = segue.destination as! MapScreenViewController
//            vc.searchItem = searchResponse
//
//            network.getWalkability(city: city, state: state) { (walkability, error) in
//                if error != nil {
//                    DispatchQueue.main.async {
//                        vc.performSegue(withIdentifier: "unwindToSearch", sender: self)
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    vc.walkability = walkability
//                    vc.setUpViews()
//                    vc.counterForBlurView -= 1
//                    vc.checkCounter()
//                }
//            }
        }
    }
    
    // MARK: - Private Functions
    
    /// Sets the gradient colors for the background view
    private func setGradientBackgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "LightBlue")!.cgColor, UIColor(named: "MedBlue")!.cgColor ]
        gradientLayer.shouldRasterize = true
        backgroundGradient.layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
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
                        self.performSegue(withIdentifier: "toCityDashboard", sender: self)
                    }
                }
                alert.addAction(noButton)
                alert.addAction(yesButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        guard formatText(text) else {
            Alert.showBasicAlert(on: self, with: "Please Enter a Valid City & State", message: "example: San Francisco, CA")
            return
        }
        conductSearch()
    }
}
