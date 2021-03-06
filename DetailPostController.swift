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
    
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postImageMain: UIImageView!
    @IBOutlet weak var commentsSection: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var especialityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var likeCounterLabel: UILabel!
    @IBOutlet weak var commentCounterLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var likeButton: UIButton!
    
    var postID:String = ""
    var profileID:String = ""
    let current = Auth.auth().currentUser?.uid
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postHeadeCell = "PostHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2.0
        profileContainer.roundedTop()
        commentsSection.roundedBottom()
        setupNavigationBarItems()
        loadLikes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchPosts()
        
        self.indicator.isHidden = true
        
    }
    
    private func setupNavigationBarItems() {
        // boton personalizado para volver atrás
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "backButtonW").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        leftButton.contentMode = .scaleAspectFit
        leftButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
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
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func profileTapped(){
        self.performSegue(withIdentifier: "profileClient", sender: self)
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        if likeButton.isSelected == true {
            likeButton.isSelected = false
            likeButton.setImage(UIImage(named : "like_selected"), for: UIControlState.normal)
            print("like")
        }
        else {
            likeButton.isSelected = true
            likeButton.setImage(UIImage(named : "Star like"), for: UIControlState.normal)
            print("unlike")
        }
        /*self.likeButton.isEnabled = false
        let ref = Database.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        ref.child("posts").child(self.postID).observe(.value) { (snapshot: DataSnapshot) in
            let updateLikes: [String : Any] = ["peopleLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
            ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                if error == nil {
                    ref.child("posts").child(self.postID).observe(.value, with: { (snpashot) in
                        if let properties = snapshot.value as? [String : Any] {
                            if let likes = properties["peopleLike"] as? [String : Any] {
                                let count = likes.count
                                self.likeCounterLabel.text = "\(count)"
                                let update = ["likeCounter": count]
                                ref.child("posts").child(self.postID).updateChildValues(update)
                                
                                self.likeButton.isHidden = true
                                self.unLikeButton.isHidden = false
                                self.likeButton.isEnabled = true
                            }
                        }
                    })
                }
            })
         ref.removeAllObservers()
        }*/
    }

    
    func fetchPosts() {
        let ref = Database.database().reference()
        
        ref.child("posts").child(postID).observe(.value) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                self.postImageMain.download(from: dict["image_url"] as? String)
                //self.likeCounterLabel.text = dict["likeCounter"] as? String
                self.profileID = dict["idEst"] as! String
                //print(self.profileID)
                self.loadClient()
            }
        }        
        ref.removeAllObservers()
    }
    func loadClient() {
        let ref = Database.database().reference()
        //print(profileID)
        ref.child("estilistas").child(profileID).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                
                self.profileNameLabel.text = "\(dict["name"] as? String ?? "Jhon") \(dict["apellido"] as? String ?? "Doe")"
                self.avatarImage.download(from: dict["urlAvatar"] as! String)
                self.especialityLabel.text = dict["especialidad"] as? String
            }
        })
        ref.removeAllObservers()
    }
    
    
    func loadLikes() {
        let ref = Database.database().reference()
        ref.child("posts").child(postID).observe(.value) { (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let likes = dict["likeCounter"]
                self.likeCounterLabel.text = "\(likes ?? 0)"
                print(likes)
            }
        }
        ref.child("posts").child(self.postID).child("peopleLike").observe(.value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.value as Any)
            
            
        })
        
    }
    
    /*func loadLikes() {
        let ref = Database.database().reference()
        let us = Auth.auth().currentUser?.uid
        ref.child("posts").child(self.postID).observe(.value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : Any] {
                if let peopleLike = properties["peopleLike"] as? [String : Any] {
                    //var counter = 0
                    //for person in peopleLike {
                        //print(person.value)
                        //print(person.key)
                    for (id, person) in peopleLike {
                        if person as? String == us {
                            print(id)
                        //se debe comparar con person.value ya que es lo que contiene el id de los usuarios que dan like
                        //pero me da un error operands of type 'Any' and 'String?'
                        //if person.key == us {
                        //if person.value as? [String : Any] == us {
                            //counter = counter + 1
                        }
                        else{
                        }
                    }
                    //no sé como quitar el optional value
                    let counter = properties["likeCounter"]
                    print(counter as Any)
                    self.likeCounterLabel.text = "\(counter ?? 0)"
                    //self.likeCounterLabel.text = (properties["likeCounter"] as Any) as? String
                }
            }
        })
    }*/
    
    
    
}

public extension UIView{
    func roundedTopLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedLeftTopRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft, .topRight, .bottomLeft],
                                     cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedRightTopLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                                     cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedTopRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottomLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottomRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedAllCorner(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight , .topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
