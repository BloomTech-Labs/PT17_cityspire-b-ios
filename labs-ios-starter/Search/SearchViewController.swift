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
    
    var searchResponse = Map()
    var network = NetworkClient()
    var city = ""
    var state = ""
    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundGradient: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackgroundColor()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let vc = segue.destination as! MapScreenViewController
            vc.searchItem = searchResponse
            
            network.getWalkability(city: city, state: state) { (walkability, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        vc.performSegue(withIdentifier: "unwindToSearch", sender: self)
                    }
                    return
                }
                DispatchQueue.main.async {
                    vc.walkability = walkability
                    vc.setUpViews()
                    vc.counterForBlurView -= 1
                    vc.checkCounter()
                }
            }
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
        city = ""
        state = ""
        guard var text = text else {
            return false
        }
        for char in text {
            if char == "," {
                text = text.replacingOccurrences(of: city, with: "")
                state = text.uppercased()
                state = state.replacingOccurrences(of: ",", with: "")
                state = state.replacingOccurrences(of: " ", with: "")
                break
            } else {
                city.append(char)
            }
        }
        city = city.capitalized
        if state.count != 2 || city.count < 2 {
            return false
        }
        searchResponse.cityName = city + ", " + state
        return true
    }
    
    /// called in searchBarSearchButtonClicked after successfully formatting text
    /// performs a search with MapKit, correcting city name spelling as needed
    /// presents user with alert to cofirm city, and upon confirmation, performs segue to city details
    private func conductSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchResponse.cityName
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            if response == nil || response?.mapItems.first?.pointOfInterestCategory != nil {
                Alert.showBasicAlert(on: self, with: "City Not Found", message: "Please try again.")
            } else {
                guard let cityName = response?.mapItems.first?.name else {
                    Alert.showBasicAlert(on: self, with: "City Not Found", message: "Please try again.")
                    return
                }
                let alert = UIAlertController(title: "View Details for \(cityName), \(self.state)?", message: nil, preferredStyle: .alert)
                let noButton = UIAlertAction(title: "Re-enter City", style: .default)
                let yesButton = UIAlertAction(title: "View City", style: .default) { _ in
                    self.city = cityName
                    self.searchResponse.cityName = cityName + ", " + self.state
                    self.searchResponse.long = (response?.boundingRegion.center.longitude)!
                    self.searchResponse.lat = (response?.boundingRegion.center.latitude)!
                    self.performSegue(withIdentifier: "toMap", sender: self)
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
