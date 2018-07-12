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
    //let status: String
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo]
    }
    
    //let status: String
    //, status: String
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        //self.status = status
        
    }
}
