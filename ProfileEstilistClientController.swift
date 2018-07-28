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

class ProfileEstilistClientController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var avatarEstilist: UIImageView!
    @IBOutlet weak var nameEstilist: UILabel!
    @IBOutlet weak var apellidoEstilist: UILabel!
    @IBOutlet weak var especialidad: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    
    var posts = [PostEstilist]()
    var estilistID: String = ""
    var estilists = [Estilist]()
    var ref : DatabaseReference!
    var indexPressedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillsCollectionView.delegate = self
        skillsCollectionView.dataSource = self
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        setupNavigationBarItems()
        avatarEstilist.layer.masksToBounds = true
        avatarEstilist.layer.cornerRadius = avatarEstilist.bounds.width / 2.0
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "barra_superior_dark.png"), for: .default)
        self.skillsCollectionView.backgroundColor = UIColor.clear
        self.feedCollectionView.backgroundColor = UIColor.clear
        loadEstilists()
        loadPosts()

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
    
    func loadEstilists() {
        //let firUser = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("estilistas").child((estilistID)).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let especialidad = dict["especialidad"] as! String
                let bio = dict["bio"] as! String
                //let estiID = dict["uid"] as! String
                self.nameEstilist.text = nombreText
                self.apellidoEstilist.text = apellidoText
                self.avatarEstilist.downloadImageEst(from: urlText)
                self.bio.text = bio
                self.especialidad.text = especialidad
                //print(estiID)
            }
        })
        ref.removeAllObservers()
    }
    
    func loadPosts() {
        let ref = Database.database().reference()
        ref.child("user-posts").child(estilistID).observe(.childAdded) { (snapshot: DataSnapshot) in
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
                self.feedCollectionView.reloadData()
            })
        }
        ref.removeAllObservers()
    }
    
    @objc func settingsTapped(){
        print("Settings Button Tapped")
    }
    
    // collectionView skills
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.skillsCollectionView {
            return 3
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath) as! SkillsCell
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCell", for: indexPath) as! PostProfileCell
            cell.postProfileImage?.download(from: self.posts[indexPath.row].imageURL)
            return cell
            
        }
    }

    // tableView feed
   /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostThumbProfileEsCell", for: indexPath) as! PostThumbProfileEsCell
        //cell.postThumb.downloadImage(from: self.posts[indexPath.row].imageURL)
        cell.postThumb?.image = UIImage(named: "studio-2.jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        self.indexPressedCell = indexPath.row
        //self.performSegue(withIdentifier: "", sender: self)
    }
    */
}

extension UIImageView {
    func download(from imgURL: String!) {
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
