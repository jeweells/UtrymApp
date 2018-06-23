//
//  StorageReference+Post.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 21/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = Auth.auth().currentUser?.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("posts/\(String(describing: uid))/\(timestamp).jpg")
    }
}
