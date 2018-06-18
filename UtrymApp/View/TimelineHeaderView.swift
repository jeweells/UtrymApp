//
//  TimelineHeaderView.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 15/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TimelineHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var logoUtrym: UIImageView!
    @IBOutlet weak var profileSettings: UIButton!
    var posts = [User]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileSettings.layer.cornerRadius = profileSettings.bounds.width / 2.0
        profileSettings.layer.masksToBounds = true
        profileSettings.layer.borderColor = UIColor.lightGray.cgColor
        profileSettings.layer.borderWidth = 1
    }
    
    
    @IBAction func profileSettingsTapped(_ sender: Any) {
        print("Profile settings tapped")
    }
    
}

