//
//  PostHeaderCell.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 12/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var showEs: UIButton!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        //Avatar.image = post.profile
        //Avatar.layer.cornerRadius = Avatar.bounds.width / 2.0
        //Avatar.layer.masksToBounds = true
        //Username.text = post.caption
        showEs.layer.borderWidth = 1.0
        showEs.layer.cornerRadius = 2.0
        showEs.layer.borderColor = showEs.tintColor.cgColor
        showEs.layer.masksToBounds = true
        
    }

}
