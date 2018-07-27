//
//  LoginController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginFacebook: UIButton!
    @IBOutlet weak var loginGoogle: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var iniciarSesion: UIButton!
    @IBOutlet weak var registrarButton: UIButton!
    

    typealias FIRUser = FirebaseAuth.User
    var handle: DatabaseHandle!
    var cliente: String = "slallaksjjs"
    var estilista: String = "sjefuaehiuf"
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print(error.localizedDescription)
            return
        }
        print("User signed into google")
        
        //guard let authentication = user.authentication else { return }
        //let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
        //                                               accessToken: authentication.accessToken)
        
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil {
                print("error sign in with google")
                return
            }
            print("User signed with google in firebase")
            
            if user != nil {
                let userID = Auth.auth().currentUser?.uid
                let user = Auth.auth().currentUser?.providerID
                
                self.ref = Database.database().reference()
                
                self.ref.child("clientes").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snapshot = snapshot.value as? NSDictionary
                    
                    if (snapshot == nil)
                    {
                        // aqui debe estar el código para crear clientes cuando se registran con google
                        // Here save client in "clientes"
                        let userInfo: [String: Any] = ["uid": userID!,
                                                       "id_perfil": self.cliente,
                                                       "provider": user as Any]
                        self.ref.child("clientes").child(userID!).setValue(userInfo)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeClient") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                        
                    }
                    else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeClient") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func loadProfile() {
        let firUser = Auth.auth().currentUser
        Database.database().reference().child("clientes").child((firUser!.uid)).child("uid").observe(.value, with: { (snapshot) in
            if (snapshot.value as? String) != nil {
                print("Cliente")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeClient") as UIViewController
                self.present(controller, animated: true, completion: nil)
            }
            else {
                print("Estilista")
                let storyboard = UIStoryboard(name: "Estilist", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeEstilist") as UIViewController
                self.present(controller, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func iniciarTapped(_ sender: UIButton) {
        
        guard username.text != "", password.text != "" else {
            let alertController = UIAlertController(title: "UtrymApp", message:
                "Debe llenar todos los campos", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if let email = username.text, let password = password.text
        {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if user != nil {
                    self.loadProfile()
                }
                else {
                    let alertController = UIAlertController(title: "UtrymApp", message:
                        "Datos inválidos \(String(describing: error?.localizedDescription))", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func facebookTapped(_ sender: UIButton) {
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
                
                if user != nil {
                    let userUid = Auth.auth().currentUser?.uid
                   
                    // Here save client in "users"
                    let userInfo: [String: Any] = ["uid": userUid!,
                                                   "id_perfil": self.cliente]
                    self.ref.child("users").child(userUid!).setValue(userInfo)
                 
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeClient") as UIViewController
                    self.present(controller, animated: true, completion: nil)
                }
                
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
            })
        }
    }
    
    
    @IBAction func googleTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func registerTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreateUsername", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }

}





