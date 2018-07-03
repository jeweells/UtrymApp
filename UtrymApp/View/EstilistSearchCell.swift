//
//  EstilistSearchCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 27/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class EstilistSearchCell: UICollectionViewCell {
    @IBOutlet weak var avatarEstilist: UIImageView!
    @IBOutlet weak var borde_avatar: UIImageView!
    @IBOutlet weak var fullNameEstilist: UILabel!
    @IBOutlet weak var buttonCitar: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarEstilist.layer.masksToBounds = true
        avatarEstilist.layer.cornerRadius = avatarEstilist.bounds.size.width / 2.0
    }
}

