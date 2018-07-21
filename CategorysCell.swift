//
//  CategorysCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 20/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation

class CategorysCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryIcon.layer.masksToBounds = true
        categoryIcon.layer.cornerRadius = 10
    }
    
}
