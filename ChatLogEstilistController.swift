//
//  ChatLogEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 2/8/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase

class ChatLogEstilistController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var chatColectionView: UICollectionView!
    @IBOutlet weak var textArea: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    
    var idClient: String = ""
    var chats1 = [ChatNew]()
    var messDict = [String: ChatMessage]()
    var keyboardAnimationDuration: NSNumber = NSNumber(floatLiteral: 0.0)
    var curve: UInt = UInt(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.delegate = self
        setupNavigationBarItems()
        self.chatColectionView.backgroundColor = UIColor.clear
        chatColectionView.register(UINib.init(nibName: "SendCell", bundle: nil), forCellWithReuseIdentifier:"SendCell")
        if let flowlayout = chatColectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        chatColectionView.register(UINib.init(nibName: "ReceivedCell", bundle: nil), forCellWithReuseIdentifier:"ReceivedCell")
        if let flowlayout = chatColectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
        chatColectionView.addGestureRecognizer(dismissKeyboardGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configView()
        loadChats()
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
    
    @objc func addTapped(){
        print("Add cita pressed")
    }
    
    @objc func keyboardWillShow(aNotification: NSNotification)    {
        keyboardAnimationDuration = aNotification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        curve = aNotification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
    }
    
    func configView() {
        //chatColectionView.rowHeight = UICollectionViewAutomaticDimension
        //chatColectionView.estimatedRowHeight = 120.0
    }
    @objc func tapCollectionView() {
        textArea.endEditing(true)
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        print("Send")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped(sendBtn)
        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(keyboardAnimationDuration)
        UIView.animate(withDuration: keyboardAnimationDuration as! Double, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.inputHeightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }, completion: { aaa in
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inputHeightConstraint.constant = 48
        self.view.layoutIfNeeded()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let item = IndexPath(row: self.chats1.count-1, section: 0)
            self.chatColectionView.scrollToItem(at: item, at: .bottom, animated: true)
        }
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
                //self.configTableView()
                self.chatColectionView.reloadData()
                self.scrollToBottom()
            })
        }
        ref.removeAllObservers()
    }
    
    
}

extension ChatLogEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats1.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentUser = Auth.auth().currentUser?.uid
        
        if currentUser == chats1[indexPath.row].enviadoPor {
            let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "SendCell", for: indexPath) as! SendCell
            print(chats1[indexPath.row].mensaje)
            cell.message.text = chats1[indexPath.row].mensaje
            chatColectionView.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            return cell
        } else {
            let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ReceivedCell", for: indexPath) as! ReceivedCell
            print(chats1[indexPath.row].mensaje)
            cell.message.text = chats1[indexPath.row].mensaje
            chatColectionView.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            return cell
        }
    }
}

