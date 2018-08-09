//
//  ListChatCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 9/8/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ListChatCell: UICollectionViewCell {
    
    @IBOutlet weak var nameEst: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeChat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
