//
//  MessageSentCell.swift
//  UtrymApp
//
//  Created by Alfredo Rodriguez on 7/29/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class MessageSentCell: UITableViewCell {

   
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //messageContainer.
        //messageContainer.roundedLeftTopRight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        messageContainer.roundedLeftTopRight()
//    }
    
}
