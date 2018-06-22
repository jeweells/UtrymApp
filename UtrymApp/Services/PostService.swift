//
//  PostService.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 21/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {        
        let currentUser = User.current
        //let post = Post(imageURL: urlString)
        let post = PostEstilist(imageURL: urlString, imageHeight: aspectHeight)
        let dict = post.dictValue
        let UserId = Auth.auth().currentUser?.uid
        let postRef = Database.database().reference().child("posts").child(UserId!).childByAutoId()
        postRef.updateChildValues(dict)
    }
    
}

