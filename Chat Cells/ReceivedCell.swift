//
//  ReceivedCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 3/8/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ReceivedCell: UICollectionViewCell {
    @IBOutlet weak var contentMessage: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView.translatesAutoresizingMaskIntoContraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConst.constant = screenWidth - (2 * 12)
    }

}
