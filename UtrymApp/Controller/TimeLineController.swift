//
//  TimeLineController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class TimeLineController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    //var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        tableView.dataSource = self
        loadPosts()
        
        //var post = Post(captionText: "test", urlString: "urltest1")
        //print(post.caption)
        //print(post.url)
    }


    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            //print(snapshot.value)
            if let dict = snapshot.value as? [String: Any] {
                let captionTex = dict["caption"] as! String
                let urlString = dict["url"] as! String
                let post = Post(captionText: captionTex, urlString: urlString)
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }

}

extension TimeLineController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        //return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        //cell.textLabel?.text = "\(indexPath.row)"
        //cell.textLabel?.text = "1"
        //cell.backgroundColor = UIColor.red
        return cell
    }
}
