//
//  FavoritesCollectionViewCell.swift
//  labs-ios-starter
//
//  Created by Jarren Campos on 2/7/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

/// Class collection view cell that holds map view, labels and buttons for the Favorites screen
class FavoritesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var cityTitleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var background: UIView!
    
}
