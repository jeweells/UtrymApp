//
//  UserNew.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserNew {
    var uid: String
    var username: String
    
    init(uidString: String, usernameString: String) {
        uid = uidString
        username = usernameString
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
    }
    
    private static var _current: UserNew?
    
    static var current: UserNew {

        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }

        return currentUser
    }
    
    static func setCurrent(_ user: UserNew) {
        _current = user
    }
}

