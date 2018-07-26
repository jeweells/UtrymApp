//
//  ProfileClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 22/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileClientController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var edit_image: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var fullNameInput: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var save: UIButton!
    var ref : DatabaseReference!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        loadClient()
        setupNavigationBarItems()
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.cornerRadius = imageProfile.bounds.width / 2.0
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Logo_inter"))
        navigationItem.titleView = titleImageView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageProfile.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadClient() {
        let firUser = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("clientes").child((firUser?.uid)!).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["nombre completo"] as! String
                let emailText = dict["email"] as! String
                let urlText = dict["urlToImage"] as! String
                //let phone = dict["phone"] as! String
                //let direccion = dict["direccion"] as! String
                self.fullNameInput.text = nombreText
                self.emailInput.text = emailText
                self.imageProfile.downloadImageEst(from: urlText)
                //self.phoneInput.text = phone
                //self.addressInput.text = direccion
            }
        })
        ref.removeAllObservers()
    }
    
    @IBAction func editImageTapped(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        print("save tapped")
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        loadClient()
    }
    
    
}
