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
    var estilistID: String = ""
    var chats = [ChatMessage]()
    var messDict = [String: ChatMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView.backgroundColor = UIColor.clear
        textMessage.delegate = self
        messagesListTV.delegate = self
        messagesListTV.dataSource = self
        self.messagesListTV.backgroundColor = UIColor.clear
        messagesListTV.register(UINib(nibName: "MessageSentCell", bundle: Bundle(for: MessageSentCell.self)), forCellReuseIdentifier: "messageSentCell")
        messagesListTV.register(UINib(nibName: "MessageReceived", bundle: Bundle(for: MessageReceived.self)), forCellReuseIdentifier: "messageReceivedCell")
        configTableView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMessagesCLient()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        loadMessagesCLient()
//    }
    
    func loadMessagesCLient() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        ref.child("user-messages").child(uid).observe(.childAdded) { (snapshot: DataSnapshot) in
            //print (snapshot)
            
            let messageId = snapshot.key
            
            Database.database().reference().child("messages").child(messageId).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any]
                {
                    let emisor = dict["emisor"] as! String
                    let receptor = dict["receptor"] as! String
                    let timestamp = dict["timestamp"] as! NSNumber
                    let message = dict["text"] as! String
                    let chat = ChatMessage(emisorText: emisor, receptorText: receptor, timestampInt: timestamp, messageText: message)
                    self.chats.append(chat)
                    
                    /*let receptor1 = chat.receptor
                    self.messDict[receptor1] = chat
                    self.chats = Array(self.messDict.values)
                    self.chats.sort(by: { (chat1, chat2) -> Bool in
                        return chat1.timestamp.intValue > chat2.timestamp.intValue
                    })*/
                    
                }
                
                self.messagesListTV.reloadData()
                self.scrollToBottom()
                
            })
        }
        ref.removeAllObservers()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": textMessage.text!, "receptor": estilistID, "emisor": fromId, "timestamp": timestamp] as [String : Any]
        //childRef().updateChildValues(values)
        //print(messageText.text!)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            self.textMessage.text = ""
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped(sendButton)
        textField.text = ""
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageSentCell", for: indexPath) as! MessageSentCell
        print(chats[indexPath.row].message)
        cell.messageText.text = chats[indexPath.row].message
        messagesListTV.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func configTableView() {
        messagesListTV.rowHeight = UITableViewAutomaticDimension
        messagesListTV.estimatedRowHeight = 120.0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chats.count-1, section: 0)
            self.messagesListTV.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
