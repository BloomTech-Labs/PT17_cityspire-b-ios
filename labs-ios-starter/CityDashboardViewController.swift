//
//  CityDashboardViewController.swift
//  labs-ios-starter
//
//  Created by Kevin Stewart on 3/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityDashboardViewController: UIViewController, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityDashboardCollectionView: UICollectionView!
    @IBOutlet weak var pinToProfileButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    // MARK: - Properties
    var city: City?
    var similarCities: [City] = []
    var cityProperties: [Int?] {
        return [city?.livability, city?.walkability, city?.traffic, city?.pollution, city?.crime, city?.rentalPrice]
    }
    
    
    // MARK: - Actions
    @IBAction func pinToProfileButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapButton.layer.cornerRadius = 15
        pinToProfileButton.layer.cornerRadius = 15
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK - Methods
    private func updateViews() {
        guard let city = city else { return }
        cityNameLabel.text = city.cityName
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityProperties.count
    }
    
    // TODO: Populate cells with properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityDashboardCell", for: indexPath) as! CityDashboardCollectionViewCell
        
        let cityProperty = cityProperties[indexPath.item]
        cell.cityPropertyNameLabel.text = "\(cityProperties[indexPath.row])"
        // cell swift ui view load progress bar
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


