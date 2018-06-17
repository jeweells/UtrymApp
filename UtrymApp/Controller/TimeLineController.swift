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
import SDWebImage

class TimeLineController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    var posts = [Post]()
    
    var Handle: DatabaseHandle = 0
    var Ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let backgroundImage = UIImage(named: "Back.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        loadPosts()
        
    }
    
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let captionTex = dict["caption"] as! String
                let urlString = dict["url"] as! String
                let post = Post(captionText: captionTex, urlString: urlString)
                self.posts.append(post)
                print(self.posts)
                self.collectionView.reloadData()
            }
        }
    }


}

extension TimeLineController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //fatalError("TODO: return number of cells")
        //return 100
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fatalError("TODO: return configured cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        //cell.itemImage.image = UIImage.init(imageLiteralResourceName: posts[indexPath.row].url)
        //cell.postImage?.image = posts[indexPath.row].url
        cell.postImage?.image = UIImage(named: "studio-2.jpg")
        
        return cell
    }
}

extension TimeLineController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let itemSize = CGSize(width: 124, height: 124)
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TimelineHeaderView", for: indexPath) as! TimelineHeaderView
        return headerView
    }
}



