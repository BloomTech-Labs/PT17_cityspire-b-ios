//
//  POITableViewCell.swift
//  labs-ios-starter
//
//  Created by Cora Jacobson on 3/19/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class POITableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: - Properties
    
    var mapItem: POIAnnotation? {
        didSet {
            nameLabel.text = mapItem?.name
        }
    }

}
