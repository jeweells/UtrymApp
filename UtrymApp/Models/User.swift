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
    
/*
    private static var _current: User?

    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
  
    static func setCurrent(_ user: User) {
        _current = user
    }*/
}


