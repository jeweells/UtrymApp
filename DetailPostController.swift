//
//  DetailPostController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 12/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class DetailPostController: UIViewController {
    
    var posts: [Post]?
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postHeadeCell = "PostHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578
    }
    
    @IBOutlet weak var tableDView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPosts()
        
//        tableDView.estimatedRowHeight = Storyboard.postCellDefaultHeight
//        tableDView.rowHeight = UITableViewAutomaticDimension
//        tableDView.separatorColor = UIColor.clear

        let backgroundImage = UIImage(named: "Back.png")
        let imageView = UIImageView(image: backgroundImage)
        
        //self.tableDView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill

    }
    
    func fetchPosts() {
        //self.posts = Post.fetchPosts()
        //self.tableDView.reloadData()
    }
    
}

extension  DetailPostController {
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if let posts = posts {
//            return posts.count
//        }
//
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = tableDView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
//
//        cell.postImage?.image = UIImage(named: "studio-2.jpg")
//        //cell.post = self.posts?[indexPath.row]
//        //cell.selectionStyle = .none
//
//        return cell
//    }
}
