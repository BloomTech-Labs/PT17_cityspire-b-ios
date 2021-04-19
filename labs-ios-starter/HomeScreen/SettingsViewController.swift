//
//  SettingsViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/26/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var walkabilityPercentageLabel: UILabel!
    @IBOutlet weak var rentalPricePercentageLabel: UILabel!
    @IBOutlet weak var crimePercentageLabel: UILabel!
    @IBOutlet weak var diversityIndexPercentageLabel: UILabel!
    @IBOutlet weak var airQualityPercentageLabel: UILabel!
    
    // MARK: - Properties
    
    var tabDelegate: TabButtonDelegate?
    var settings: [CGFloat] = [20, 20, 20, 20, 20]
    let colors: [UIColor] = [UIColor(named: "PieChartPurple")!, UIColor(named: "PieChartGreen")!, UIColor(named: "PieChartRed")!, UIColor(named: "PieChartYellow")!, UIColor(named: "PieChartBlue")!]
    let defaults = UserDefaults.standard
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var settingInts: [Int] = []
        for float in settings {
            let int = Int(float)
            settingInts.append(int)
        }
        defaults.setValue(settingInts, forKey: "Settings")
        
        let alert = UIAlertController(title: "Saved!", message: "Your settings have been saved.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        for i in 0..<settings.count {
            settings[Int(i)] = CGFloat(20)
        }
        resetLabels()
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        var savedFloats: [CGFloat] = []
        if let savedSettings = defaults.object(forKey: "Settings") as? [Int] {
            for int in savedSettings {
                let float = CGFloat(int)
                savedFloats.append(float)
            }
        }
        if savedFloats == settings {
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Your settings have not been saved.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            let leaveButton = UIAlertAction(title: "Leave Anyway", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelButton)
            alert.addAction(leaveButton)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func pinButtonPressed(_ sender: Any) {
        var savedFloats: [CGFloat] = []
        if let savedSettings = defaults.object(forKey: "Settings") as? [Int] {
            for int in savedSettings {
                let float = CGFloat(int)
                savedFloats.append(float)
            }
        }
        if savedFloats == settings {
            dismiss(animated: false) {
                self.tabDelegate?.pinsSelected()
            }
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Your settings have not been saved.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            let leaveButton = UIAlertAction(title: "Leave Anyway", style: .destructive) { _ in
                self.dismiss(animated: false) {
                    self.tabDelegate?.pinsSelected()
                }
            }
            alert.addAction(cancelButton)
            alert.addAction(leaveButton)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func minusWalkability(_ sender: UIButton) {
        settings[0] -= 1
        if settings[0] >= 0 {
            walkabilityPercentageLabel.text = "\(Int(settings[0]))%"
            updatePieChartValues()
        } else {
            settings[0] += 1
        }
    }
    
    @IBAction func plusWalkability(_ sender: UIButton) {
        settings[0] += 1
        if settings[0] >= 0 {
            walkabilityPercentageLabel.text = "\(Int(settings[0]))%"
            updatePieChartValues()
        } else {
            settings[0] -= 1
        }
    }
    
    @IBAction func minusRentalPrice(_ sender: UIButton) {
        settings[1] -= 1
        if settings[1] >= 0 {
            rentalPricePercentageLabel.text = "\(Int(settings[1]))%"
            updatePieChartValues()
        } else {
            settings[1] += 1
        }
    }
    
    @IBAction func plusRentalPrice(_ sender: UIButton) {
        settings[1] += 1
        if settings[1] >= 0 {
            rentalPricePercentageLabel.text = "\(Int(settings[1]))%"
            updatePieChartValues()
        } else {
            settings[1] -= 1
        }
    }
    
    @IBAction func minusCrime(_ sender: UIButton) {
        settings[2] -= 1
        if settings[2] >= 0 {
            crimePercentageLabel.text = "\(Int(settings[2]))%"
            updatePieChartValues()
        } else {
            settings[2] += 1
        }
    }
    
    @IBAction func plusCrime(_ sender: UIButton) {
        settings[2] += 1
        if settings[2] >= 0 {
            crimePercentageLabel.text = "\(Int(settings[2]))%"
            updatePieChartValues()
        } else {
            settings[2] -= 1
        }
    }
    
    @IBAction func minusDiversityIndex(_ sender: UIButton) {
        settings[3] -= 1
        if settings[3] >= 0 {
            diversityIndexPercentageLabel.text = "\(Int(settings[3]))%"
            updatePieChartValues()
        } else {
            settings[3] += 1
        }
    }
    
    @IBAction func plusDiversityIndex(_ sender: UIButton) {
        settings[3] += 1
        if settings[3] >= 0 {
            diversityIndexPercentageLabel.text = "\(Int(settings[3]))%"
            updatePieChartValues()
        } else {
            settings[3] -= 1
        }
    }
    
    @IBAction func minusAirQuality(_ sender: UIButton) {
        settings[4] -= 1
        if settings[4] >= 0 {
            airQualityPercentageLabel.text = "\(Int(settings[4]))%"
            updatePieChartValues()
        } else {
            settings[4] += 1
        }
    }
    
    @IBAction func plusAirQuality(_ sender: UIButton) {
        settings[4] += 1
        if settings[4] >= 0 {
            airQualityPercentageLabel.text = "\(Int(settings[4]))%"
            updatePieChartValues()
        } else {
            settings[4] -= 1
        }
    }
    
    // MARK: - Private Functions
    
    private func updatePieChartValues() {
        pieChartView.backgroundColor = UIColor.clear
        let chartView = PieChartView()
        var segments: [PieChartSegment] = []
        chartView.frame = CGRect(x: 0, y: 0, width: pieChartView.frame.size.width, height: pieChartView.frame.size.height)
        for index in 0..<settings.count {
            let chartSegment = PieChartSegment(color: colors[index], value: settings[index])
            segments.append(chartSegment)
        }
        pieChartView.segments = segments
        pieChartView.addSubview(chartView)
        updateLabels()
    }
    
    private func resetLabels() {
        settings = [20, 20, 20, 20, 20]
        updatePieChartValues()
    }
    
    private func updateLabels() {
        let sum = CGFloat(settings.reduce(0, +))
        walkabilityPercentageLabel.text = "\(Int(settings[0] / sum * 100))%"
        rentalPricePercentageLabel.text = "\(Int(settings[1] / sum * 100))%"
        crimePercentageLabel.text = "\(Int(settings[2] / sum * 100))%"
        diversityIndexPercentageLabel.text = "\(Int(settings[3] / sum * 100))%"
        airQualityPercentageLabel.text = "\(Int(settings[4] / sum * 100))%"
    }
    
    private func setUpViews() {
        guard let settingInts = defaults.object(forKey: "Settings") as? [Int] else {
            updatePieChartValues()
            return
        }
        settings = []
        for int in settingInts {
            let float = CGFloat(int)
            settings.append(float)
        }
        updatePieChartValues()
    }
}
