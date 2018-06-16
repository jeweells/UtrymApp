//
//  SignUpController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 13/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Pass: UITextField!
    @IBOutlet weak var ConfirmPass: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var SelectImage: UIButton!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    let picker = UIImagePickerController()
    var userStorage : StorageReference!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        let storage = Storage.storage(url:"gs://utrymapp-f55e4.appspot.com")
        let storageRef = storage.reference()
        userStorage = storageRef.child("avatares")
        ref = Database.database().reference()
        FullName.delegate = self
        Email.delegate = self
        Pass.delegate = self
        ConfirmPass.delegate = self
        ProfileImage.layer.cornerRadius = ProfileImage.bounds.width / 2.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func scrollClick(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func SelectImage(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    // Ocultar teclado cuando se mantenga presionada la tecla return en cualquiera de los inputs
    
    func textFieldShouldReturn(FullName: UITextField) -> Bool {
        FullName.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ Email: UITextField) -> Bool {
        Email.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(Pass: UITextField) -> Bool {
        Pass.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(ConfirmPass: UITextField) -> Bool {
        ConfirmPass.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.ProfileImage.image = image
            SignUpButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        guard FullName.text != "", Email.text != "", Pass.text != "", ConfirmPass.text != "" else { return }
        let email = Email.text
        let pass = Pass.text
        if Pass.text == ConfirmPass.text {
            
            Auth.auth().createUser(withEmail: email!, password: pass!) { (user, error) in
            
                if let error = error {
                    let alertController = UIAlertController(title: "UtrymApp", message:
                        "Error en los datos suministrados: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    print(error.localizedDescription)
                    print("Failed to signUp1: \(error.localizedDescription)")
                }
                
                if user != nil {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.FullName.text!
                    changeRequest?.commitChanges(completion: nil)
                    
                    let UserId = Auth.auth().currentUser?.uid
                    let imageRef = self.userStorage.child("\(UserId!).jpg")
                    let data = UIImageJPEGRepresentation(self.ProfileImage.image!, 0.5)
                    
                    let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                        guard metadata != nil else {
                            return
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                let alertController = UIAlertController(title: "UtrymApp", message:
                                    "Error al cargar la imagen: \(er!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                                
                                print("Error al cargar la imagen: \(er!.localizedDescription)")
                            }
                            
                            if let url = url {
                                let userInfo: [String: Any] = ["uid": UserId!,
                                                               "nombre completo": self.FullName.text!,
                                                               "urlToImage": url.absoluteString]
                                self.ref.child("clientes").child(UserId!).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                        })
                    }
                    
                    uploadTask.resume()
                    
                }
                
            }
        }
        else {
            let alertController = UIAlertController(title: "UtrymApp", message:
                "Contraseñas no coinciden", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            print("Pass no coinciden")
        }
        
    }
    
    // Ocultar teclado cuando se toca en cualquier parte de la vista
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        FullName.resignFirstResponder()
        Email.resignFirstResponder()
        Pass.resignFirstResponder()
        ConfirmPass.resignFirstResponder()
    }
    
}






















