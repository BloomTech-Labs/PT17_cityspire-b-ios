//
//  MapScreenViewController.swift
//  labs-ios-starter
//
//  Created by Jarren Campos on 2/3/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit
import CoreData

/// Class to control mapView and city information to be retrieved
class MapScreenViewController: UIViewController {

    // Context for CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - IBOutlets
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!

    @IBOutlet var mapView: MKMapView!

    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var employmentLabel: UILabel!
    @IBOutlet var averageAgeLabel: UILabel!
    @IBOutlet var livabilityLabel: UILabel!
    @IBOutlet var rentalPriceLabel: UILabel!
    @IBOutlet var walkabilityLabel: UILabel!
    @IBOutlet var averageIncomeLabel: UILabel!

    @IBOutlet var popUpTitleLabel: UILabel!
    @IBOutlet var popUpTextView: UITextView!

    // MARK: - Properties
    var counterForBlurView: Int = 1
    var searchItem = Map()
    var walkability: Walkability?
    var employmentStatement: String = ""
    var walkabilityStatement: String = ""
    var incomeStatement: String = ""
    var ageStatement: String = ""
    var livabilityStatement: String = ""
    var rentalStatement: String = ""

    var activityView = UIActivityIndicatorView(style: .large)

    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        animateIn(desiredView: blurView, mid: true)
        activityView.center = self.view.center
        activityView.color = UIColor(named: "LightBlue")
        self.view.addSubview(activityView)
        activityView.startAnimating()

        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)

        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(searchItem.lat, searchItem.long)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)

        cityLabel.text = searchItem.cityName

        blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        popUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 1.5, height: self.view.frame.height / 3.5)
        popUpView.layer.cornerRadius = 5.0
    }

    func checkCounter(){
        if counterForBlurView == 0{
            activityView.stopAnimating()
            animateOut(desiredView: blurView)
        }
    }

    /// Sets the card view the user tapped on to display more information
    func setUpViews() {
        walkabilityLabel.text = "\(walkability!.walkability)"

    }

    // MARK: - IBActions
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToSearch", sender: self)
    }
    @IBAction func favoriteCityPressed(_ sender: Any) {
        let favorite = Favorite(context: context)
        favorite.lat = searchItem.lat
        favorite.lon = searchItem.long
        favorite.name = searchItem.cityName
        favorite.walkabilityScore = Int64(walkability!.walkability)

        do {
            try context.save()
        }
        catch {
            print("error saving data")
        }
    }

    @IBAction func employmentPressed(_ sender: Any) {
        popUpTextView.text = employmentStatement
        animateIn(desiredView: blurView, mid: true)
        animateIn(desiredView: popUpView, mid: true)
        popUpTitleLabel.text = "Employment"
    }

    @IBAction func walkabilityPressed(_ sender: Any) {
        popUpTextView.text = walkabilityStatement
        animateIn(desiredView: blurView, mid: true)
        animateIn(desiredView: popUpView, mid: true)
        popUpTitleLabel.text = "Walkability"
    }

    @IBAction func averageAgePressed(_ sender: Any) {
        popUpTextView.text = ageStatement
        animateIn(desiredView: blurView, mid: true)
        animateIn(desiredView: popUpView, mid: true)
        popUpTitleLabel.text = "Average Age"
    }

    @IBAction func livabilityPressed(_ sender: Any) {
        popUpTextView.text = livabilityStatement
        animateIn(desiredView: blurView, mid: true)
        animateIn(desiredView: popUpView, mid: true)
        popUpTitleLabel.text = "Livability"
    }

    @IBAction func rentalPressed(_ sender: Any) {
        popUpTextView.text = rentalStatement
        animateIn(desiredView: blurView, mid: true)
        animateIn(desiredView: popUpView, mid: true)
        popUpTitleLabel.text = "Average Rent"
    }

    @IBAction func averageIncome(_ sender: Any) {
        popUpTextView.text = incomeStatement
        animateIn(desiredView: blurView, mid: true)
        animateIn(desiredView: popUpView, mid: true)
        popUpTitleLabel.text = "Average Income"
    }

    @IBAction func cancelPopUpView(_ sender: Any) {
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurView)
        popUpTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    func animateIn(desiredView: UIView, mid: Bool) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)

        if mid == false{
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
            desiredView.center = CGPoint(x: backgroundView.center.x, y: backgroundView.center.y - 100)
        } else {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
            desiredView.center = backgroundView.center
        }

        UIView.animate(withDuration: 0.3) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        }
    }

    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
}

extension MapScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CityMain")
        switch annotation.title {
        case "For Rent":
            annotationView.markerTintColor = UIColor(named: "AccentYellow")
            annotationView.glyphImage = UIImage(systemName: "house.fill")
        case "For Sale":
            annotationView.markerTintColor = UIColor(named: "LightBlue")
            annotationView.glyphImage = UIImage(systemName: "dollarsign.circle.fill")
        default:
            annotationView.markerTintColor = UIColor(named: "LightBlue")
        }
        return annotationView
    }
}
