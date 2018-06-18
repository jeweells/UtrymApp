//
//  ServiceHeaderCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 18/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ServiceHeaderCell: UICollectionReusableView {
    
    @IBOutlet weak var utrymLogo: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileButton.layer.cornerRadius = profileButton.bounds.width / 2.0
        profileButton.layer.masksToBounds = true
        profileButton.layer.borderColor = UIColor.lightGray.cgColor
        profileButton.layer.borderWidth = 1
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        print("Profile settings tapped from services")
    }
    
}


