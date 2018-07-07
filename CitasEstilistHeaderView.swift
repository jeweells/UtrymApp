//
//  CitasEstilistHeaderView.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 5/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class CitasEstilistHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var chatsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatsButton.layer.masksToBounds = true
        chatsButton.layer.cornerRadius = 10
    }

}
