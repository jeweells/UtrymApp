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

class ChatLogClientController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatArea: UIView!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var estilistID: String = ""
    var chats = [ChatMessage]()
    var messDict = [String: ChatMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clear
        loadMessagesCLient()
        textMessage.delegate = self
    
    }
    
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
                self.collectionView.reloadData()
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
    


}

extension ChatLogClientController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 10
        return chats.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "MessageClientCell", for: indexPath) as! MessageClientCell
        //cell.nameService?.text = services[indexPath.row].nombre
        //cell.priceService?.text = services[indexPath.row].precio
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        /*let backgroundImage = UIImage(named: "list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10*/
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.textMessage?.text = chats[indexPath.row].message

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        //self.indexPressedCell = indexPath.row
        //self.performSegue(withIdentifier: "listServices", sender: self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handledKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func handledKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
        }
    }
    

}

extension ChatLogClientController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 3
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 80)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
