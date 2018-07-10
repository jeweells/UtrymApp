//
//  ProfileEstilistClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 8/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileEstilistClientController: UIViewController, UICollectionViewDataSource, UITableViewDelegate {

    @IBOutlet weak var avatarEstilist: UIImageView!
    @IBOutlet weak var nameEstilist: UILabel!
    @IBOutlet weak var apellidoEstilist: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var postFeedCollectionView: UICollectionView!
    
    var skills = ["skill1", "skill2", "skill3"]
    var posts = ["post1", "post2", "post3", "post4", "post5","post6" ]
    
    var estilistID: String = ""
    var estilists = [Estilist]()
    var ref : DatabaseReference!
    let collectionViewAIdentifier = "SkillsCell"
    let collectionViewBIdentifier = "PostThumbProfileEstCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        avatarEstilist.layer.masksToBounds = true
        avatarEstilist.layer.cornerRadius = avatarEstilist.bounds.width / 2.0
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "barra_superior_dark.png"), for: .default)
        self.skillsCollectionView.backgroundColor = UIColor.clear
        self.postFeedCollectionView.backgroundColor = UIColor.clear
        
     /*   skillsCollectionView.delegate = self as? UICollectionViewDelegate
        postFeedCollectionView.delegate = self as? UICollectionViewDelegate
        
        skillsCollectionView.dataSource = self as? UICollectionViewDataSource
        postFeedCollectionView.dataSource = self as? UICollectionViewDataSource
        
        self.view.addSubview(skillsCollectionView)
        self.view.addSubview(postFeedCollectionView)*/
        
        //let backgroundImage = UIImage(named: "Back_profile_only.png")
        //let imageView = UIImageView(image: backgroundImage)
        //self.collectionView.backgroundView = imageView
        //loadEstilists()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Mask_avatar").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    @objc func settingsTapped(){
        print("Settings Button Tapped")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == skillsCollectionView {
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return 3
            }
        }
        else {
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return 50
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath) as! SkillsCell
            //cell.postEst?.image = UIImage(named: "card-profile7.jpg")
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbProfileEstCell", for: indexPath) as! PostThumbProfileEstCell
            //cell.postImage.downloadImage(from: self.posts[indexPath.row].url)
            cell.postThumb?.image = UIImage(named: "studio-2.jpg")
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == postFeedCollectionView {
            //self.performSegue(withIdentifier: "detail", sender: self)
            print("Detail Post Tapped")
        }
        
    }
    
    
    /*func loadEstilists() {
        let ref = Database.database().reference()
        ref.child("estilistas").child(estilistID).observe(.value) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let estiID = dict["uid"] as! String
                let estilist = Estilist(nombreText: nombreText, apellidoText: apellidoText, urlText: urlText, estiID: estiID)
                self.estilists.append(estilist)
                print("\(self.estilists)")
                //print(self.estilists)
                
                self.collectionView.reloadData()
            }
        }
        ref.removeAllObservers()
    }*/
 /*
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath) as! SkillsCell
            
            // Set up cell
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbProfileEstCell", for: indexPath) as! PostThumbProfileEstCell
            
            // ...Set up cell
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.skillsCollectionView {
            return 2 // Replace with count of your data for collectionViewA
        }
        
        else {
            return 20 // Replace with count of your data for collectionViewB
        }
    }

}*/

}



    /*
extension ProfileEstilistClientController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fatalError("TODO: return configured cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbProfileEstCell", for: indexPath) as! PostThumbProfileEstCell
        //cell.postImage.downloadImage(from: self.posts[indexPath.row].url)
        cell.postImage?.image = UIImage(named: "studio-2.jpg")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "detail", sender: self)
        print("Detail Post Tapped")
    }
}

extension ProfileEstilistClientController: UICollectionViewDelegateFlowLayout {
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
    
}*/

