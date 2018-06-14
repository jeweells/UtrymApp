//
//  ViewController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 27/5/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    

    //@IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signFaceButton: UIButton!
    @IBOutlet weak var sigInGoogleButton: GIDSignInButton!
    
    
    var ref: DatabaseReference!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
//    @IBAction func SignInSegmentorChanged(_ sender: UISegmentedControl) {
//
//        isSignIn = !isSignIn
//
 //       if isSignIn {
 //           signInLabel.text = "Registrarse"
 //           signInButton.setTitle("Registrarse", for: .normal)
//        }

//    }
    @IBAction func SignInButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if user != nil {
                    
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    print("Usuario autenticado")
                }
                else {
                    let alertController = UIAlertController(title: "UtrymApp", message:
                        "El usuario no existe, favor Registrarse", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("Usuario no existe favor registrarse")
                }
            }
            //else {
            //    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            //        let userID = Auth.auth().currentUser?.uid
            //        self.ref = Database.database().reference()
            //        if user != nil {
            //            self.ref.child("clientes").child(userID!).child("email").setValue(email)
            //            self.ref.child("clientes").child(userID!).child("password").setValue(password)
            //            self.performSegue(withIdentifier: "goToHome", sender: self)
            //            print("Usuario creado")
            //        }
            //        else {
            //
            //        }
            //    }
            //}
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // Present the Welcome View Controller
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
    }
    
    @IBAction func googlePlusButtonTouchUpInside(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

