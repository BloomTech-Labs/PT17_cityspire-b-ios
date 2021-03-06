//
//  MapViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var zoomSlider: UISlider!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableOutline: UIView!
    
    // MARK: - Properties
    
    var city: City?
    let categories = CategoryList()
    var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    var mapItems: [POIAnnotation] = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zoomChangedValue(_ sender: UISlider) {
        span.latitudeDelta = 0.1 - CLLocationDegrees(sender.value)
        span.longitudeDelta = 0.1 - CLLocationDegrees(sender.value)
        mapView.setRegion(MKCoordinateRegion(center: mapView.region.center, span: span), animated: true)
    }
    
    @IBAction func zoomInPressed(_ sender: UIButton) {
        if span.latitudeDelta >= 0.02 {
            span.latitudeDelta -= 0.01
            span.longitudeDelta -= 0.01
            zoomSlider.setValue(zoomSlider.value + 0.01, animated: true)
        } else {
            span.latitudeDelta = 0.01
            span.longitudeDelta = 0.01
            zoomSlider.setValue(0.09, animated: true)
        }
        mapView.setRegion(MKCoordinateRegion(center: mapView.region.center, span: span), animated: true)
    }
    
    @IBAction func zoomOutPressed(_ sender: UIButton) {
        if span.latitudeDelta <= 0.09 {
            span.latitudeDelta += 0.01
            span.longitudeDelta += 0.01
            zoomSlider.setValue(zoomSlider.value - 0.01, animated: true)
        } else {
            span.latitudeDelta = 0.1
            span.longitudeDelta = 0.1
            zoomSlider.setValue(0, animated: true)
        }
        mapView.setRegion(MKCoordinateRegion(center: mapView.region.center, span: span), animated: true)
    }
    
    @IBAction func poiChosen() {
        let category = categories.cats[pickerView.selectedRow(inComponent: 0)]
        requestPointsOfInterest(category: category)
    }
    
    // MARK: - Private Functions
    
    private func setUpView() {
        tableView.isHidden = true
        tableOutline.isHidden = true
        guard let city = city else { return }
        cityLabel.text = city.cityName + ", " + city.cityState
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(city.latitude, city.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifier.poiAnnotation)
        pickerView.layer.borderColor = UIColor(named: "DarkishBlue")?.cgColor
        pickerView.layer.borderWidth = 1
    }
    
    /// The user will be able to select a map item category. Once the category is selected, the map view will add annotations for all items matching the category within the region that the user is currently over on the map.
    /// Note: MapKit appears to have a 25 item limit on results from a point of interest search
    /// - Parameter category: Accepts a point of interest item from a list of categories shown in a picker format.
    private func requestPointsOfInterest(category: POICategory) {
        if span.latitudeDelta > 0.03 {
            span.latitudeDelta = 0.03
            span.longitudeDelta = 0.03
            zoomSlider.setValue(0.07, animated: true)
            mapView.setRegion(MKCoordinateRegion(center: mapView.region.center, span: span), animated: true)
        }
        mapView.removeAnnotations(mapItems)
        mapItems = []
        tableView.reloadData()
        let request = MKLocalPointsOfInterestRequest(coordinateRegion: mapView.region)
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [category.category])
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                Alert.showBasicAlert(on: self, with: "Sorry!", message: "Your search did not return any results. Try centering the map on the area you want to search")
                return
            }
            let items = response.mapItems
            for item in items {
                let coordinate = item.placemark.coordinate
                let annotation = POIAnnotation(coordinate: coordinate, name: item.name, category: category)
                self.mapItems.append(annotation)
            }
            self.mapView.addAnnotations(self.mapItems)
            self.tableView.isHidden = false
            self.tableOutline.isHidden = false
            self.tableView.reloadData()
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let poi = annotation as? POIAnnotation else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifier.poiAnnotation, for: poi) as! MKMarkerAnnotationView
        annotationView.markerTintColor = UIColor(named: "DarkAccentGreen")
        annotationView.titleVisibility = .hidden
        annotationView.canShowCallout = true
        annotationView.displayPriority = .required
        let detailView = POIDetailView()
        detailView.poi = poi
        annotationView.detailCalloutAccessoryView = detailView
        return annotationView
    }
}

extension MapViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.cats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        pickerLabel.textAlignment = .center
        pickerLabel.text = categories.cats[row].plural
        pickerLabel.textColor = UIColor(named: "DarkBlue")
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mapView.removeAnnotations(mapItems)
        mapItems = []
        tableView.reloadData()
        self.tableView.isHidden = true
        self.tableOutline.isHidden = true
    }
}

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mapItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poiCell") as! POITableViewCell
        cell.mapItem = mapItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! POITableViewCell
        if let mapItem = cell.mapItem {
            mapView.selectAnnotation(mapItem, animated: true)
        }
    }
}
