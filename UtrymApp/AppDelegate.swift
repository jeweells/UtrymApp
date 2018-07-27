//
//  AppDelegate.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 27/5/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var cliente: String = "slallaksjjs"
    var ref: DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        
        if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
        // Firebase
        FirebaseApp.configure()

        
        // Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
        
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                 annotation: nil)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication,
                                                 annotation: annotation)
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
                
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snapshot = snapshot.value as? NSDictionary
                    
                    if (snapshot == nil)
                    {
                        // aqui debe estar el código para crear clientes cuando se registran con google
                        // Here save client in "users"
                        let userInfo: [String: Any] = ["uid": userID!,
                                                       "id_perfil": self.cliente,
                                                       "provider": user as Any]
                        self.ref.child("users").child(userID!).setValue(userInfo)
                        
                        // home client debo redireccionar
                        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewControlleripad : UIViewController = (mainStoryboardIpad.instantiateViewController(withIdentifier: "WelcomeClient") as? ClientTabBarController)!
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = initialViewControlleripad
                        self.window?.makeKeyAndVisible()

                    }
                    else {
                        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewControlleripad : UIViewController = (mainStoryboardIpad.instantiateViewController(withIdentifier: "WelcomeClient") as? ClientTabBarController)!
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = initialViewControlleripad
                        self.window?.makeKeyAndVisible()
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

