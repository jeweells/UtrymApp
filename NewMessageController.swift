//
//  NewMessageController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 14/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewMessageController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageArea: UIView!
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var messageText: UITextField!
    var ref : DatabaseReference!
    var estilistID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": messageText.text!, "receptor": estilistID, "emisor": fromId, "timestamp": timestamp] as [String : Any]
        childRef().updateChildValues(values)
        print(messageText.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped(sendMessage)
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
