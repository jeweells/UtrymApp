//
//  Message.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Message {
    
    var key: String?
    let content: String
    let timestamp: Date
    let sender: UserNew
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.content = content
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.sender = UserNew(uidString: uid, usernameString: username)
    }
    
    init(content: String) {
        self.content = content
        self.timestamp = Date()
        self.sender = UserNew.current
    }
    
    var dictValue: [String : Any] {
        let userDict = ["username" : sender.username,
                        "uid" : sender.uid]
        
        return ["sender" : userDict,
                "content" : content,
                "timestamp" : timestamp.timeIntervalSince1970]
    }
}
