//
//  ProfileHeaderView.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 15/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var citasButton: UIButton!
    @IBOutlet weak var calif: UIButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var apellido: UILabel!
    @IBOutlet weak var profesion: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var skills: UIImageView!
    var ref : DatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadEstilists()
        imageProfile.layer.cornerRadius = imageProfile.bounds.width / 2.0
        imageProfile.layer.masksToBounds = true
        skills.layer.masksToBounds = true
        skills.layer.cornerRadius = 10
    }
    
    func loadEstilists() {
        let firUser = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("estilistas").child((firUser!.uid)).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let especialidad = dict["especialidad"] as! String
                let bio = dict["bio"] as! String
                //let estiID = dict["uid"] as! String
                self.fullName.text = nombreText
                self.apellido.text = apellidoText
                self.imageProfile.downloadImage(from: urlText)
                self.bio.text = bio
                self.profesion.text = especialidad
                //print(estiID)
            }
        })
        ref.removeAllObservers()
    }

}

