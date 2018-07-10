//
//  UserNew.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation

class UserNew {
    var uid: String
    var username: String
    
    init(uidString: String, usernameString: String) {
        uid = uidString
        username = usernameString
    }
    
    // 1
    private static var _current: UserNew?
    
    // 2
    static var current: UserNew {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    static func setCurrent(_ user: UserNew) {
        _current = user
    }
}

