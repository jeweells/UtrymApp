//
//  ForgotPasswordController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 8/8/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class ForgotPasswordController: UIViewController {

    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mail.resignFirstResponder()
    }
    
    func textFieldShouldReturn(FullName: UITextField) -> Bool {
        mail.resignFirstResponder()
        return true
    }
    
    @IBAction func goBtnTapped(_ sender: UIButton) {
        SVProgressHUD.show()
        guard mail.text != "" else {
            SVProgressHUD.dismiss()
            let alertController = UIAlertController(title: "UtrymApp", message:
                "Debe escribir un correo", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if let email = mail.text {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error != nil
                {
                    SVProgressHUD.dismiss()
                    let alertController = UIAlertController(title: "UtrymApp", message:
                        "Correo no existe", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                    SVProgressHUD.dismiss()
                    let alertController = UIAlertController(title: "UtrymApp", message:
                        "Le ha sido enviado un link para recuperar su contraseña a su correo electrónico", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    self.mail.text = ""
                }
                
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
