//
//  PostEstilist.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 21/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class PostEstilist {
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    var status: Bool = false
    var idEst: String
    var likeCounter: Int = 0
    var peopleLike: [String] = [String]()
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "status_post" : status,
                "idEst": idEst,
                "likeCounter": likeCounter,
                "peopleLike": peopleLike]
    }

    init(imageURL: String, imageHeight: CGFloat, idEst: String) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.idEst = idEst
    }
}














































