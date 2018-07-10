//
//  UserService.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

struct UserService {
    
    static func observeChats(for user: UserNew = UserNew.current, withCompletion completion: @escaping (DatabaseReference, [ChatNew]) -> Void) -> DatabaseHandle {
        let ref = Database.database().reference().child("chats").child(user.uid)
        
        return ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion(ref, [])
            }
            
            let chats = snapshot.compactMap(ChatNew.init)
            completion(ref, chats)
        })
    }
    
    static func following(for user: UserNew = UserNew.current, completion: @escaping ([UserNew]) -> Void) {
        let followingRef = Database.database().reference().child("estilistas").child(user.uid)
        followingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followingDict = snapshot.value as? [String : Bool] else {
                return completion([])
            }

            var following = [UserNew]()
            let dispatchGroup = DispatchGroup()
            
            for uid in followingDict.keys {
                dispatchGroup.enter()
                
                show(forUID: uid) { user in
                    if let user = user {
                        following.append(user)
                    }
                    
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(following)
            }
        })
    }
    
    static func show(forUID uid: String, completion: @escaping (UserNew?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
           /* guard let user = UserNew(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)*/
        })
    }
    
    static func create(_ firUser: UserNew, username: String, completion: @escaping (UserNew?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                /*let user = UserNew(snapshot: snapshot)
                completion(user)*/
            })
        }
    }
}
