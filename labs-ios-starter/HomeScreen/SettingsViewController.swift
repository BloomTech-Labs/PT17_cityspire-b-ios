//
//  SettingsViewController.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/26/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var tabDelegate: TabButtonDelegate?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            self.tabDelegate?.pinsSelected()
        }
    }

}
