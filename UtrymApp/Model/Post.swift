//
//  Post.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 11/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
class Post {
    var caption: String
    var url: String
    
    init(captionText: String, urlString: String) {
        caption = captionText
        url = urlString
    }
}
