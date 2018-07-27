//
//  CreateUserController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateUserController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //var cliente: String = "slallaksjjs"
    
    @IBOutlet weak var addAvatarRegister: UIButton!
    @IBOutlet weak var avatarRegister: UIImageView!
    @IBOutlet weak var fullNameRegister: UITextField!
    @IBOutlet weak var usernameRegister: UITextField!
    @IBOutlet weak var passwordRegister: UITextField!
    @IBOutlet weak var passRegister: UITextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        fullNameRegister.delegate = self
        usernameRegister.delegate = self
        passwordRegister.delegate = self
        passRegister.delegate = self
        avatarRegister.layer.masksToBounds = true
        avatarRegister.layer.cornerRadius = avatarRegister.bounds.size.width / 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAvatarTapped(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.avatarRegister.image = image
            //SignUpButton.isHidden = false
            addAvatarRegister.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func registerTapped(_ sender: Any) {
        guard fullNameRegister.text != "", usernameRegister.text != "", passwordRegister.text != "", passRegister.text != "" else {
            let alertController = UIAlertController(title: "UtrymApp", message:
                "Debe llenar todos los campos", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
            
        }
        let email = usernameRegister.text
        let pass = passwordRegister.text
        if passwordRegister.text == passRegister.text {
            
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
                    changeRequest?.displayName = self.fullNameRegister.text!
                    changeRequest?.commitChanges(completion: nil)
                    
                    let UserId = Auth.auth().currentUser?.uid
                    let imageRef = self.userStorage.child("\(UserId!).jpg")
                    let data = UIImageJPEGRepresentation(self.avatarRegister.image!, 0.5)
                    
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
                                                               "nombre completo": self.fullNameRegister.text!,
                                                               "username": email!,
                                                               "password": pass!,
                                                               //"id_perfil": self.cliente,
                                                               "urlToImage": url.absoluteString]
                                self.ref.child("clientes").child(UserId!).setValue(userInfo)
                                
                                // al registrarse enviar directamente a la pantalla de unicio
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeClient") as UIViewController
                                self.present(controller, animated: true, completion: nil)
                                
                                // al redireccionar al home no muestra el navigation bar ni el tab bar
                                /*let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
                                self.present(vc, animated: true, completion: nil)*/
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
    
    @IBAction func cancelTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        //self.performSegue(withIdentifier: "backToLogin", sender: self)
    }
    
    // Ocultar teclado cuando se toca en cualquier parte de la vista
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fullNameRegister.resignFirstResponder()
        usernameRegister.resignFirstResponder()
        passwordRegister.resignFirstResponder()
        passRegister.resignFirstResponder()
    }
    
    
}

