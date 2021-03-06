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
    var categorys = [CategoryProfile]()
    
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
        
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "backButtonW").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        leftButton.contentMode = .scaleAspectFit
        leftButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
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
                self.nameEstilist?.text = "\(nombreText) \(apellidoText)"
                //self.nameEstilist.text = nombreText
                //self.apellidoEstilist.text = apellidoText
                self.avatarEstilist.download(from: urlText)
                self.bio.text = bio
                self.especialidad.text = especialidad
                //print(estiID)
            }
        })
        ref.removeAllObservers()
    }
    
    func loadCategorys() {
        let ref = Database.database().reference()
        ref.child("estilistas").child((estilistID)).child("categorys").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let cat = dict["nombre"] as? String
                let category = CategoryProfile(nombreText: cat!)
                self.categorys.append(category)
            }
            self.skillsCollectionView.reloadData()
        }
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
    
    @IBAction func chatsTapped(_ sender: UIButton) {
        if sender == chatButton {
            self.performSegue(withIdentifier: "chatProfile", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ChatProfileController {
            print("Me fui a chatear con: \(estilistID)")
            destinationController.estilistID = estilistID
        }
    }
    
    
    // collectionView skills
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.skillsCollectionView {
            return categorys.count
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath) as! SkillsCell
            let backgroundImage = UIImage(named: "cat_prof_fondo.png")
            let imageView = UIImageView(image: backgroundImage)
            cell.backgroundView = imageView
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
            
            let nombreCat = categorys[indexPath.row].nombre
            
            switch nombreCat {
            case "Makeup":
                cell.imsgeSkills?.image = UIImage(named: "makeup_peq.png")
            case "Hair":
                cell.imsgeSkills?.image = UIImage(named: "hair_peq.png")
            case "Nails":
                cell.imsgeSkills?.image = UIImage(named: "manicure_peq.png")
            default:
                cell.imsgeSkills?.image = UIImage(named: "hair_peq.png")
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCell", for: indexPath) as! PostProfileCell
            cell.postProfileImage?.download(from: self.posts[indexPath.row].imageURL)
            return cell
            
        }
    }
}

extension ProfileEstilistClientController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.feedCollectionView {
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
        if collectionView == self.feedCollectionView {
            return 1.5
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.feedCollectionView {
            return 1.5
        }
        return 1
    }
}

public extension UIImageView {
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
