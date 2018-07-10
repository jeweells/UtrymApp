//
//  ChatListClientCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ChatListClientCell: UITableViewCell {
    
    @IBOutlet weak var titleMessage: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
