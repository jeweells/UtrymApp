//
//  User.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 12/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import UIKit

class User {
    var username: String
    var avatar: UIImage
    
    init(usernameString: String, ProfileImage: UIImage) {
        username = usernameString
        avatar = ProfileImage
    }
}
