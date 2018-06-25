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

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        
        let backgroundImage = UIImage(named: "Back.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        loadPosts()
        
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Mask_avatar").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        //let leftIcon = UIButton(type: .system)
        //leftIcon.setImage(#imageLiteral(resourceName: "backButtonW"), for: .normal)
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)
    }
    
    @objc func profileTapped(){
        //show(ProfileClientController(), sender: self)
        self.performSegue(withIdentifier: "profileClient", sender: self)
    }
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                //let captionTex = dict["caption"] as! String
                let urlString = dict["url"] as! String
                let post = Post(urlString: urlString)
                //let post = Post(captionText: captionTex, urlString: urlString)
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
        return 50
        //return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fatalError("TODO: return configured cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        //cell.postImage.downloadImage(from: self.posts[indexPath.row].url)
        cell.postImage?.image = UIImage(named: "studio-2.jpg")
        
        return cell
    }
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
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
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TimelineHeaderView", for: indexPath) as! TimelineHeaderView
        return headerView
    }*/
}



