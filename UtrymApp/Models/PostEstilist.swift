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
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "status_post" : status]
    }
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        
    }
}
