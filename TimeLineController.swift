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
    
    var posts = [PostEstilist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(logout), with: nil, afterDelay: 0)
        }
        //let backgroundImage = UIImage(named: "Back.png")
        //let imageView = UIImageView(image: backgroundImage)
        //self.collectionView.backgroundView = imageView
        //imageView.contentMode = .scaleAspectFill
        self.collectionView.backgroundColor = UIColor.clear
        loadPosts()
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    private func setupNavigationBarItems(){
        // logo Utrym en el centro del NavBar
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        // icono avatar botón derecho del NavBar
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Setting_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    

    
    @objc func profileTapped(){
        self.performSegue(withIdentifier: "profileClient", sender: self)
    }
 
    func loadPosts() {
        /*let ref = Database.database().reference().child("posts")
        let query = ref.queryOrdered(byChild: "status_post").queryEqual(toValue:true)
        query.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            print(snapshot)
        }*/
        let ref = Database.database().reference()
        ref.child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
        //Database.database().reference().child("posts").observe(.value) { (snapshot: DataSnapshot) in
            //print(snapshot)
            if let dict = snapshot.value as? [String: Any] {
                let imageURL = dict["image_url"] as? String
                let image_height = dict["image_height"] as? CGFloat
                let idEst = dict["idEst"] as? String
                let post = PostEstilist(imageURL: imageURL!, imageHeight: image_height!, idEst: idEst!)
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }
        ref.removeAllObservers()
    }
}

extension TimeLineController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //fatalError("TODO: return number of cells")
        //return 50
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fatalError("TODO: return configured cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        cell.postImage.downloadImage(from: self.posts[indexPath.row].imageURL)
        //cell.postImage?.image = UIImage(named: "studio-2.jpg")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: self)
        print("Detail Post Tapped")
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



