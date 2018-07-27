//
//  ChatsEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 5/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ChatsEstilistController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //var chats = [Chat]()
    var chats = [ChatMessage]()
    var messDict = [String: ChatMessage]()
    var clients = [Client]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        setupNavigationBarItems()
        let backgroundImage = UIImage(named: "Background_list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        //loadChats()
        loadChatsUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
    }
    
    @objc func addTapped(){
        
    }
    
    
    func loadChatsUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("messages").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for mens in snapshot.children.allObjects as! [DataSnapshot] {
                    //print(mens)
                    let obj = mens.value as? [String: Any]
                    print(obj!)
                    let emisor = obj!["emisor"] as! String
                    let receptor = obj!["receptor"] as! String
                    let timestamp = obj!["timestamp"] as! NSNumber
                    let message = obj!["text"] as! String
                    if receptor == uid {
                        let chat = ChatMessage(emisorText: emisor, receptorText: receptor, timestampInt: timestamp, messageText: message)
                        let emisor1 = chat.emisor
                        self.messDict[emisor1] = chat
                        self.chats = Array(self.messDict.values)
                        self.chats.sort(by: { (chat1, chat2) -> Bool in
                            return chat1.timestamp.intValue > chat2.timestamp.intValue
                        })
                        self.collectionView.reloadData()
                    }
                    
                    //print(obj!)
                }
            }
        })
        
        
        
        //let ref = Database.database().reference().child("user-messages").child(uid)
        //ref.observe(.childAdded, with: { (snapshot) in
            //print (snapshot)
        
            //let messageId = snapshot.key
            
        
           /* Database.database().reference().child("messages").child(messageId).observe(.value, with: { (snapshot) in
                //print(snapshot)
                if let dict = snapshot.value as? [String: Any]
                {
                    let emisor = dict["emisor"] as! String
                    let receptor = dict["receptor"] as! String
                    let timestamp = dict["timestamp"] as! NSNumber
                    let message = dict["text"] as! String
                    let chat = ChatMessage(emisorText: emisor, receptorText: receptor, timestampInt: timestamp, messageText: message)
                    //self.chats.append(chat)
                    
                    let emisor1 = chat.emisor
                    self.messDict[emisor1] = chat
                    self.chats = Array(self.messDict.values)
                    self.chats.sort(by: { (chat1, chat2) -> Bool in
                        return chat1.timestamp.intValue > chat2.timestamp.intValue
                    })
                    self.collectionView.reloadData()
                }
            })*/
        //})
        //ref.removeAllObservers()
    }
    
    
    /*func loadChats() {
        
        let ref = Database.database().reference()
        
        ref.child("chats").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let clienteText = dict["cliente"] as! String
                let fechaText = dict["fecha"] as! String
                let chat = Chat(clienteText: clienteText, fechaText: fechaText)
                self.chats.append(chat)
                
                Database.database().reference().child("clientes").child(clienteText).observe(.value) { (snapshot: DataSnapshot) in
                    if let dict = snapshot.value as? [String: Any] {
                        let fullNameText = dict["nombre completo"] as! String
                        let urlText = dict["urlToImage"] as! String
                        let client = Client(fullNameText: fullNameText, urlText: urlText)
                        self.clients.append(client)
                    }
                self.collectionView.reloadData()
                }
            }
        }
        ref.removeAllObservers()
    }*/

}

extension ChatsEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ListChatsEstilistCell", for: indexPath) as! ListChatsEstilistCell
        //cell.clientFullName?.text = clients[indexPath.row].fullName
        //cell.fechaChats?.text = chats[indexPath.row].fecha
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        /*let backgroundImage = UIImage(named: "list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10*/
        let mensaje = chats[indexPath.row]
        cell.clientFullName?.text = mensaje.emisor
        cell.textMessage?.text = mensaje.message

        let seconds = mensaje.timestamp.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        cell.fechaChats?.text = dateFormatter.string(from: timestampDate as Date)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        return cell
    }
}



extension ChatsEstilistController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 115)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
