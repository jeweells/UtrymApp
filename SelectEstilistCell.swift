//
//  SelectEstilistCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 12/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class SelectEstilistCell: UICollectionViewCell {
    
    @IBOutlet weak var imageEstilist: UIImageView!
    @IBOutlet weak var nombreEstilist: UILabel!
    @IBOutlet weak var apellidoEstilist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageEstilist.layer.masksToBounds = true
        imageEstilist.layer.cornerRadius = imageEstilist.bounds.size.width / 2.0
    }
}
