//
//  PostCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 12/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        self.postImage.image = postImage.image
        
    }

}
