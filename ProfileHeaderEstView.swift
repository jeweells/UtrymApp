//
//  ProfileHeaderEstView.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 8/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ProfileHeaderEstView: UICollectionReusableView {
    

    @IBOutlet weak var avatarEstilist: UIImageView!
    @IBOutlet weak var nombreEst: UILabel!
    @IBOutlet weak var apellidoEst: UILabel!
    @IBOutlet weak var skillEst: UIImageView!
    @IBOutlet weak var bioEst: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarEstilist.layer.masksToBounds = true
        avatarEstilist.layer.cornerRadius = avatarEstilist.bounds.width / 2.0
        skillEst.layer.masksToBounds = true
        skillEst.layer.cornerRadius = 10
    }
    
}
