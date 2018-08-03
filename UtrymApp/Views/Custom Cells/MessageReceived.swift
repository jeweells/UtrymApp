//
//  MessageReceived.swift
//  UtrymApp
//
//  Created by Alfredo Rodriguez on 7/28/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class MessageReceived: UITableViewCell {

    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //messageContainer.roundedRightTopLeft()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
