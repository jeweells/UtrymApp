//
//  ProfileEstController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 22/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileEstController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var nameEst: UILabel!
    @IBOutlet weak var apellidoEst: UILabel!
    @IBOutlet weak var espEst: UILabel!
    @IBOutlet weak var bioEst: UILabel!
    @IBOutlet weak var skills: UICollectionView!
    @IBOutlet weak var feed: UICollectionView!

    var posts = [PostEstilist]()
    var estilists = [Estilist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "barra_superior_dark.png"), for: .default)
        self.skills.backgroundColor = UIColor.clear
        self.feed.backgroundColor = UIColor.clear
        profImage.layer.masksToBounds = true
        profImage.layer.cornerRadius = profImage.bounds.width / 2.0
        loadPosts()
        loadEst()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Setting_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)

    }
    
    @objc func settingsTapped(){
        print("Settings Button Tapped")
    }
    
    func loadEst() {
        let firUser = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("estilistas").child((firUser?.uid)!).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let bio = dict["bio"] as! String
                let especialidad = dict["especialidad"] as! String
                self.nameEst.text = nombreText
                self.apellidoEst.text = apellidoText
                self.profImage.downloadImageEst(from: urlText)
                self.bioEst.text = bio
                self.espEst.text = especialidad
            }
        })
        ref.removeAllObservers()
    }
    
    func loadPosts() {
        let estilistID = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("user-posts").child((estilistID?.uid)!).observe(.childAdded) { (snapshot: DataSnapshot) in
            //print (snapshot)
            let postId = snapshot.key
            
            Database.database().reference().child("posts").child(postId).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any]
                {
                    let imageURL = dict["image_url"] as? String
                    let image_height = dict["image_height"] as? CGFloat
                    let idEst = dict["idEst"] as? String
                    let post = PostEstilist(imageURL: imageURL!, imageHeight: image_height!, idEst: idEst!)
                    self.posts.append(post)
                }
                self.feed.reloadData()
            })
        }
        ref.removeAllObservers()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.skills {
            return 3
        }
        //return 10
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.skills {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsHomeProfileCell", for: indexPath) as! SkillsHomeProfileCell
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostEstThumbProfileCell", for: indexPath) as! PostEstThumbProfileCell
            cell.postEst?.downloadI(from: self.posts[indexPath.row].imageURL)
            //cell.postEst?.image = UIImage(named: "studio-2.jpg")
            return cell
            
        }
    }
    
}


extension UIImageView {
    func downloadI(from imgURL: String!) {
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


extension ProfileEstController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.feed {
            let columns: CGFloat = 3
            let spacing: CGFloat = 1.5
            let totalHorizontalSpacing = (columns - 1) * spacing
    
            let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
            let itemSize = CGSize(width: itemWidth, height: itemWidth)
    
            return itemSize
        }
        
        let itemSize = CGSize(width: 40, height: 40)
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.feed {
            return 1.5
        }
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.feed {
            return 1.5
        }
        return 3
    }
    
    
}

