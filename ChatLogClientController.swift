//
//  ChatLogClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 15/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatLogClientController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatArea: UIView!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messagesListTV: UITableView!
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    
    var estilistID: String = ""
    //var chats = [ChatMessage]()
    var chats1 = [ChatNew]()
    var messDict = [String: ChatNew]()
    var keyboardAnimationDuration: NSNumber = NSNumber(floatLiteral: 0.0)
    var curve: UInt = UInt(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textMessage.delegate = self
        messagesListTV.delegate = self
        messagesListTV.dataSource = self
        self.messagesListTV.keyboardDismissMode = .interactive
        self.messagesListTV.backgroundColor = UIColor.clear
//        messagesListTV.register(UINib(nibName: "MessageSentCell", bundle: Bundle(for: MessageSentCell.self)), forCellReuseIdentifier: "messageSentCell")
//        messagesListTV.register(UINib(nibName: "MessageReceived", bundle: Bundle(for: MessageReceived.self)), forCellReuseIdentifier: "messageReceivedCell")
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(tapTableView))
        messagesListTV.addGestureRecognizer(dismissKeyboardGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //configTableView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        loadMessagesCLient()
//        configTableView()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        configTableView()
        loadChats()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
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
                    
                    /* este query solo carga los 2 más recientes
                    let receptor = chat.recibidoPor
                    self.messDict[receptor] = chat
                    self.chats1 = Array(self.messDict.values)

                    self.chats1.sort(by: { (message1, message2) -> Bool in
                        return message1.hora.intValue < message2.hora.intValue
                    })*/
                }
                self.configTableView()
                self.messagesListTV.reloadData()
                self.scrollToBottom()
            })
        }
        ref.removeAllObservers()
    }
    
    @objc func keyboardWillShow(aNotification: NSNotification)    {
        /*if let keyboardSize = (aNotification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }*/
        keyboardAnimationDuration = aNotification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        curve = aNotification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        
        textMessage.endEditing(true)
        
        let ref = Database.database().reference().child("chats-messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser!.uid
        let hora = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        if textMessage.text != "" {
            let values = ["mensaje": textMessage.text!, "enviadoPor": fromId, "recibidoPor": estilistID, "hora": hora] as [String : Any]
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                else {
                    let userMessageRef = Database.database().reference().child("chat-usuario").child(fromId)
                    let estMessageRef = Database.database().reference().child("chat-usuario").child(self.estilistID)
                    let messageId = childRef.key
                    userMessageRef.updateChildValues([messageId: "1"])
                    estMessageRef.updateChildValues([messageId: "1"])
                    self.textMessage.text = ""
                }
            }
        }
    }
    
    @objc func tapTableView() {
        textMessage.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped(sendButton)
        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(keyboardAnimationDuration)
        UIView.animate(withDuration: keyboardAnimationDuration as! Double, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            //se debe colocar como valor lo que ocupe el teclado segun cada iphone, hay un comando que da ese valor por el momento con esta medida se ve bien en el x
            //ahora solo falta que se suba tambien el tableview junto con el input
            self.inputHeightConstraint.constant = 356
            self.view.layoutIfNeeded()
        }, completion: { aaa in
            //(value: Bool) in println()
        })
//        UIView.animate(withDuration: keyboardAnimationDuration as! Double){
//            self.inputHeightConstraint.constant = 308
//            self.view.layoutIfNeeded()
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //UIView.animate(withDuration: 0.5){
            self.inputHeightConstraint.constant = 48
            self.view.layoutIfNeeded()
        //}
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentUser = Auth.auth().currentUser?.uid
        if currentUser == chats1[indexPath.row].enviadoPor {
            if let mycell = cell as? MessageSentCell{
                //mycell.messageContainer.roundedLeftTopRight()
                mycell.messageContainer.clipsToBounds = true
                mycell.messageContainer.layer.cornerRadius = 10
                mycell.messageContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            }
        } else {
            if let mycell = cell as? MessageReceived{
                //mycell.messageContainer.roundedRightTopLeft()
                mycell.messageContainer.clipsToBounds = true
                mycell.messageContainer.layer.cornerRadius = 10
                mycell.messageContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentUser = Auth.auth().currentUser?.uid
        
        if currentUser == chats1[indexPath.row].enviadoPor {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageSentCell", for: indexPath) as! MessageSentCell
            cell.messageText.text = chats1[indexPath.row].mensaje
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageReceivedCell", for: indexPath) as! MessageReceived
            cell.messageText.text = chats1[indexPath.row].mensaje
            return cell
        }
        /*
        let currentUser = Auth.auth().currentUser?.uid
        
        if currentUser == chats[indexPath.row].emisor {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageSentCell", for: indexPath) as! MessageSentCell
            print(chats[indexPath.row].message)
            cell.messageText.text = chats[indexPath.row].message
            messagesListTV.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageReceivedCell", for: indexPath) as! MessageReceived
            print(chats[indexPath.row].message)
            cell.messageText.text = chats[indexPath.row].message
            messagesListTV.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            return cell
        }
        */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return chats.count
        return chats1.count
    }

    func configTableView() {
        messagesListTV.rowHeight = UITableViewAutomaticDimension
        messagesListTV.estimatedRowHeight = 120.0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            /*let indexPath = IndexPath(row: self.chats.count-1, section: 0)*/
            let indexPath = IndexPath(row: self.chats1.count-1, section: 0)
            self.messagesListTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

}

//extension ChatLogClientController: UICollectionViewDataSource {
//    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //return 10
//        return chats.count
//    }
//
//    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "MessageClientCell", for: indexPath) as! MessageClientCell
//        //cell.nameService?.text = services[indexPath.row].nombre
//        //cell.priceService?.text = services[indexPath.row].precio
//        //cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
//        /*let backgroundImage = UIImage(named: "list_estilist.png")
//        let imageView = UIImageView(image: backgroundImage)
//        cell.backgroundView = imageView
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = 10*/
//        cell.layer.cornerRadius = 16
//        cell.layer.masksToBounds = true
//        cell.textMessage?.text = chats[indexPath.row].message
//        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
//        let lastItemIndex = NSIndexPath(item: item, section: 0)
//        collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: false)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        print("User tapped on item \(indexPath.row)")
//        //self.indexPressedCell = indexPath.row
//        //self.performSegue(withIdentifier: "listServices", sender: self)
//    }
//
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handledKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    }
//
//    @objc func handledKeyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//            print(keyboardHeight)
//        }
//    }
//
//
//}
//
//extension ChatLogClientController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let columns: CGFloat = 1
//        let spacing: CGFloat = 3
//        let totalHorizontalSpacing = (columns) * spacing
//
//        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
//        let itemSize = CGSize(width: itemWidth, height: 80)
//
//        return itemSize
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//}
