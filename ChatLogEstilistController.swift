//
//  ChatLogEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 2/8/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ChatLogEstilistController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableChat: UITableView!
    @IBOutlet weak var textArea: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var heigthInput: NSLayoutConstraint!
    
    
    var idClient: String = ""
    var chats1 = [ChatNew]()
    var keyboardAnimationDuration: NSNumber = NSNumber(floatLiteral: 0.0)
    var curve: UInt = UInt(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.delegate = self
        setupNavigationBarItems()
        self.tableChat.backgroundColor = UIColor.clear
        self.tableChat.keyboardDismissMode = .interactive
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(tapTableView))
        tableChat.addGestureRecognizer(dismissKeyboardGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configTableView()
        loadChats()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "add_cita").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    func loadChats() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        ref.child("chat-usuario").child(uid).observe(.childAdded) { (snapshot: DataSnapshot) in
            let messageId = snapshot.key
            Database.database().reference().child("chats-messages").child(messageId).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any]
                {
                    let enviadoPor = dict["enviadoPor"] as! String
                    let recibidoPor = dict["enviadoPor"] as! String
                    let hora = dict["hora"] as! NSNumber
                    let mensaje = dict["mensaje"] as! String
                    let chat = ChatNew(enviadoPorText: enviadoPor, recibidoPorText: recibidoPor, horaInt: hora, mensajeText: mensaje)
                    self.chats1.append(chat)
                }
                self.configTableView()
                self.tableChat.reloadData()
                self.scrollToBottom()
            })
        }
        ref.removeAllObservers()
    }
    
    @objc func addTapped(){
        print("Add cita pressed")
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        textArea.endEditing(true)
        
        let ref = Database.database().reference().child("chats-messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser!.uid
        let hora = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        if textArea.text != "" {
            let values = ["mensaje": textArea.text!, "enviadoPor": fromId, "recibidoPor": idClient, "hora": hora] as [String : Any]
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                else {
                    let userMessageRef = Database.database().reference().child("chat-usuario").child(fromId)
                    let estMessageRef = Database.database().reference().child("chat-usuario").child(self.idClient)
                    let messageId = childRef.key
                    userMessageRef.updateChildValues([messageId: "1"])
                    estMessageRef.updateChildValues([messageId: "1"])
                    self.textArea.text = ""
                }
            }
        }
    }
    
    @objc func tapTableView() {
        textArea.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)    {
        keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped(sendBtn)
        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(keyboardAnimationDuration)
        UIView.animate(withDuration: keyboardAnimationDuration as! Double, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            //se debe colocar como valor lo que ocupe el teclado segun cada iphone, hay un comando que da ese valor por el momento con esta medida se ve bien en el x
            //ahora solo falta que se suba tambien el tableview junto con el input
            self.heigthInput.constant = 356
            self.view.layoutIfNeeded()
        }, completion: { aaa in
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.heigthInput.constant = 48
        self.view.layoutIfNeeded()
    }
    
    func configTableView() {
        tableChat.rowHeight = UITableViewAutomaticDimension
        tableChat.estimatedRowHeight = 120.0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chats1.count-1, section: 0)
            self.tableChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    
    
    
}


