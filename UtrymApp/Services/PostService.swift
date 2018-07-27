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
            let idEst = Auth.auth().currentUser?.uid
            // la imagen se guarda en Storage pero no en la base de datosssssss y de paso no se como subir los videos
            createPost(forURLString: urlString, aspectHeight: aspectHeight, idEst: idEst!)
        }
    }
    
    private static func createPost(forURLString urlString: String, aspectHeight: CGFloat, idEst: String) {
        let post = PostEstilist(imageURL: urlString, imageHeight: aspectHeight, idEst: idEst)
        let dict = post.dictValue
        let UserId = Auth.auth().currentUser?.uid
        let postRef = Database.database().reference().child("posts").child(UserId!).childByAutoId()
        postRef.updateChildValues(dict)
    }
    
}



