//
//  FavoritesViewController.swift
//  labs-ios-starter
//
//  Created by Jarren Campos on 1/27/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreData
import MapKit

/// Class to handle logic for Favorites screen collection view
class FavoritesViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet var colletionView: UICollectionView!
    @IBOutlet private var mapView: MKMapView!
    
    // MARK: - Properties

    var favorites: [Favorite]?
    var mapItems: [FavAnnotation] = []
    var city: City?
    var controller: ApiController?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tabDelegate: TabButtonDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifier.favAnnotation)
        fetchFavorites()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesToCity",
           let city = city {
            let cityDashboardVC = segue.destination as! CityDashboardViewController
            cityDashboardVC.cityStack.append(city)
            cityDashboardVC.controller = controller
            cityDashboardVC.tabDelegate = self
        }
    }

    // MARK: - IBActions
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            self.tabDelegate?.settingsSelected()
        }
    }
    
    // MARK: - Private Functions
    
    private func fetchFavorites() {
        do {
            self.favorites = try context.fetch(Favorite.fetchRequest())
            DispatchQueue.main.async {
                self.colletionView.reloadData()
                self.mapView.removeAnnotations(self.mapItems)
                self.mapItems = []
                guard let favorites = self.favorites else { return }
                for favorite in favorites {
                    guard let cityName = favorite.cityName,
                          let stateName = favorite.stateName else { return }
                    let coordinate = CLLocationCoordinate2D(latitude: favorite.latitude, longitude: favorite.longitude)
                    let fullCityName = cityName + ", " + stateName
                    let annotation = FavAnnotation(coordinate: coordinate, cityName: fullCityName)
                    self.mapItems.append(annotation)
                }
                self.mapView.addAnnotations(self.mapItems)
            }
        }
        catch {
            print("error fetching data")
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        cell.cityTitleLabel.text = favorites![indexPath.row].cityName! + ", " + favorites![indexPath.row].stateName!
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 8)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let city = favorites?[indexPath.row],
              let cityName = city.cityName,
              let stateName = city.stateName else { return }
        controller?.fetchCityData(city: City(cityName: cityName, cityState: stateName), completion: { favoriteCity in
            self.city = favoriteCity
            if self.city?.latitude == 0 || self.city?.longitude == 0 {
                self.city?.latitude = city.latitude
                self.city?.longitude = city.longitude
            }
            self.performSegue(withIdentifier: "favoritesToCity", sender: self)
        })
    }

    @objc func buttonClicked(sender: UIButton) {
        self.context.delete(self.favorites![sender.tag])
        do {
            try self.context.save()
            self.fetchFavorites()
        }
        catch {
            print("error deleting")
        }
    }

}

extension FavoritesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let fav = annotation as? FavAnnotation else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifier.favAnnotation, for: fav) as! MKMarkerAnnotationView
        annotationView.titleVisibility = .hidden
        annotationView.displayPriority = .required
        annotationView.canShowCallout = true
        let detailView = FavDetailView()
        detailView.fav = fav
        annotationView.detailCalloutAccessoryView = detailView
        return annotationView
    }
}

extension FavoritesViewController: TabButtonDelegate {
    func homeSelected() {
        dismiss(animated: false, completion: nil)
    }
    
    func pinsSelected() {
    }
    
    func settingsSelected() {
        dismiss(animated: false) {
            self.tabDelegate?.settingsSelected()
        }
    }
}
