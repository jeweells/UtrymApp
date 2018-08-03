//
//  SendCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 2/8/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class SendCell: UICollectionViewCell {
    @IBOutlet weak var contentMessage: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //contentView.translatesAutoresizingMaskIntoContraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConst.constant = screenWidth - (2 * 12)
        
        contentMessage.layer.masksToBounds = true
        //contentMessage.layer.cornerRadius = (corners: [.bottomLeft, .bottomRight], radius: 3.0)
        //contentMessage(corners: [.bottomLeft, .bottomRight], radius: 3.0)
    }

}
