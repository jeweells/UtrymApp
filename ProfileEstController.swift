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
    @IBOutlet weak var espEst: UILabel!
    @IBOutlet weak var bioEst: UILabel!
    @IBOutlet weak var skills: UICollectionView!
    @IBOutlet weak var feed: UICollectionView!
    @IBOutlet weak var ranking: UIImageView!
    
    var posts = [PostEstilist]()
    var estilists = [Estilist]()
    var categorys = [CategoryProfile]()
    let estilistID = Auth.auth().currentUser
    
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
        loadCategorys()
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
        let alert = UIAlertController(title: "Confirme:", message: "Segur@ que desea cerrar sesión?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "login") as UIViewController
                self.present(controller, animated: true, completion: nil)
                print("Estilista cerró sesión")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func loadEst() {
        let ref = Database.database().reference()
        ref.child("estilistas").child((estilistID?.uid)!).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let bio = dict["bio"] as! String
                let especialidad = dict["especialidad"] as! String
                self.nameEst.text = "\(nombreText) \(apellidoText)"
                self.profImage.downloadImage(from: urlText)
                self.bioEst.text = bio
                self.espEst.text = especialidad
            }
        })
        ref.removeAllObservers()
    }
    
    func loadPosts() {
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
    
    func loadCategorys() {
        let ref = Database.database().reference()
        ref.child("estilistas").child((estilistID?.uid)!).child("categorys").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let cat = dict["nombre"] as? String
                let category = CategoryProfile(nombreText: cat!)
                self.categorys.append(category)
            }
            self.skills.reloadData()
        }
        ref.removeAllObservers()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.skills {
            return categorys.count
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.skills {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsHomeProfileCell", for: indexPath) as! SkillsHomeProfileCell
            let backgroundImage = UIImage(named: "cat_prof_fondo.png")
            let imageView = UIImageView(image: backgroundImage)
            cell.backgroundView = imageView
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
            
            let nombreCat = categorys[indexPath.row].nombre
            
            switch nombreCat {
            case "Makeup":
                cell.skill?.image = UIImage(named: "makeup_peq.png")
            case "Hair":
                cell.skill?.image = UIImage(named: "hair_peq.png")
            case "Nails":
                cell.skill?.image = UIImage(named: "manicure_peq.png")
            default:
                cell.skill?.image = UIImage(named: "hair_peq.png")
            }
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
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.feed {
            return 1.5
        }
        return 1
    }
    
    
}

