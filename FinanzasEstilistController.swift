//
//  FinanzasEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 6/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FinanzasEstilistController: UIViewController {

    @IBOutlet weak var avatarEstilist: UIImageView!
    @IBOutlet weak var nombreEstilist: UILabel!
    @IBOutlet weak var ranking: UIImageView!
    @IBOutlet weak var especialidad: UILabel!
    
    let estilistID = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        setupNavigationBarItems()
        avatarEstilist.layer.masksToBounds = true
        avatarEstilist.layer.cornerRadius = avatarEstilist.bounds.width / 2.0
        loadEst()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
    }
    
    func loadEst() {
        let ref = Database.database().reference()
        ref.child("estilistas").child((estilistID?.uid)!).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                //let bio = dict["bio"] as! String
                let especialidad = dict["especialidad"] as! String
                self.nombreEstilist?.text = "\(nombreText) \(apellidoText)"
                self.avatarEstilist.downloadImageEst(from: urlText)
                //self.bioEst.text = bio
                self.especialidad.text = especialidad
            }
        })
        ref.removeAllObservers()
    }

}
