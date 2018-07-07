//
//  ProfileHeaderView.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 15/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var citasButton: UIButton!
    @IBOutlet weak var calif: UIButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profesion: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var skills: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageProfile.layer.cornerRadius = imageProfile.bounds.width / 2.0
        imageProfile.layer.masksToBounds = true
        //imageProfile.layer.borderColor = UIColor.red.cgColor
        //imageProfile.layer.borderWidth = 1
        //skills.layer.cornerRadius = skills.bounds.width / 2.0
        skills.layer.masksToBounds = true
        skills.layer.cornerRadius = 10
        
    }
        
}
