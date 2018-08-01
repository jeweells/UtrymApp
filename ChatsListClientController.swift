//
//  ChatsListClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatsListClientController: UIViewController {
    
    var estilists = [Estilist]()
    var chats1 = [ChatNew]()
    var messDict1 = [String: ChatNew]()
    var chats = [ChatMessage]()
    var messDict = [String: ChatMessage]()
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?
    var indexPressedCell: Int = 0
    @IBOutlet weak var chatsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatsTable.rowHeight = 71
        // remove separators for empty cells
        chatsTable.tableFooterView = UIView()
        self.chatsTable.backgroundColor = UIColor.clear
        //loadChats()
        //loadChatsUsers()
        agroupChatsByEstilist()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func agroupChatsByEstilist() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        ref.child("chat-usuario").child(uid).observe(.childAdded) { (snapshot: DataSnapshot) in
            //print (snapshot)
            
            let messageId = snapshot.key
            
            Database.database().reference().child("chats-messages").child(messageId).observe(.value, with: { (snapshot) in
                //print(snapshot)
                if let dict = snapshot.value as? [String: Any]
                {
                    let enviadoPor = dict["enviadoPor"] as! String
                    let recibidoPor = dict["recibidoPor"] as! String
                    let hora = dict["hora"] as! NSNumber
                    let mensaje = dict["mensaje"] as! String
                    let chat = ChatNew(enviadoPorText: enviadoPor, recibidoPorText: recibidoPor, horaInt: hora, mensajeText: mensaje)
                    //self.chats1.append(chat)
                    
                    let receptor = chat.recibidoPor
                    self.messDict1[receptor] = chat
                    self.chats1 = Array(self.messDict1.values)
                    print (self.chats1)
                    self.chats1.sort(by: { (chat1, chat2) -> Bool in
                        return chat1.hora.intValue > chat2.hora.intValue
                    })
                    
                }
                self.chatsTable.reloadData()
            })
        }
        ref.removeAllObservers()
        
    }
    
    
    /*func loadChatsUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        ref.child("user-messages").child(uid).observe(.childAdded) { (snapshot: DataSnapshot) in
            //print (snapshot)
            
            let messageId = snapshot.key

            Database.database().reference().child("messages").child(messageId).observe(.value, with: { (snapshot) in
                //print(snapshot)
                if let dict = snapshot.value as? [String: Any]
                {
                    let emisor = dict["emisor"] as! String
                    let receptor = dict["receptor"] as! String
                    let timestamp = dict["timestamp"] as! NSNumber
                    let message = dict["text"] as! String
                    let chat = ChatMessage(emisorText: emisor, receptorText: receptor, timestampInt: timestamp, messageText: message)
                    //self.chats.append(chat)
                    
                    let receptor1 = chat.receptor
                    self.messDict[receptor1] = chat
                    self.chats = Array(self.messDict.values)
                    print (self.chats)
                    self.chats.sort(by: { (chat1, chat2) -> Bool in
                        return chat1.timestamp.intValue > chat2.timestamp.intValue
                    })
                    
                }
            self.chatsTable.reloadData()
            })
        }
        ref.removeAllObservers()
    }*/
    
/*
    func loadChats() {
        
        let ref = Database.database().reference()
        ref.child("messages").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let emisor = dict["emisor"] as! String
                let receptor = dict["receptor"] as! String
                let timestamp = dict["timestamp"] as! NSNumber
                let message = dict["text"] as! String
                let chat = ChatMessage(emisorText: emisor, receptorText: receptor, timestampInt: timestamp, messageText: message)
                //self.chats.append(chat)
                let receptor1 = chat.receptor
                self.messDict[receptor1] = chat
                self.chats = Array(self.messDict.values)
                self.chats.sort(by: { (chat1, chat2) -> Bool in
                    return chat1.timestamp.intValue > chat2.timestamp.intValue
                })
                
                Database.database().reference().child("estilistas").child(receptor).observe(.value) { (snapshot: DataSnapshot) in
                    if let dict = snapshot.value as? [String: Any] {
                        let name = dict["name"] as! String
                        let apellido = dict["apellido"] as! String
                        let urlText = dict["urlAvatar"] as! String
                        let estiID = dict["uid"] as! String
                        let estilist = Estilist(nombreText: name, apellidoText: apellido, urlText: urlText, estiID: estiID)
                        self.estilists.append(estilist)
                    }
                self.chatsTable.reloadData()
                }
            }
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ChatLogClientController {
            //print("Inicé chat con: \(chats[indexPressedCell].receptor)")
            print("Inicé chat con: \(chats1[indexPressedCell].recibidoPor)")
            //Siempre almacena solo el primer elemento, esta fallando
            destinationController.estilistID = chats1[indexPressedCell].recibidoPor
            //destinationController.estilistID = chats[indexPressedCell].receptor
        }
    }
}


extension ChatsListClientController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListClientCell") as! ChatListClientCell
        let mensaje = chats1[indexPath.row]
        cell.titleMessage?.text = mensaje.recibidoPor
        cell.textMessage?.text = mensaje.mensaje
        
        let seconds = mensaje.hora.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        cell.lastMessage?.text = dateFormatter.string(from: timestampDate as Date)
        
        //cell.lastMessage?.text = chats[indexPath.row].timestamp
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        return cell
        
        /*let mensaje = chats[indexPath.row]
        cell.titleMessage?.text = mensaje.receptor
        cell.textMessage?.text = mensaje.message
        
        let seconds = mensaje.timestamp.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        cell.lastMessage?.text = dateFormatter.string(from: timestampDate as Date)
        
        //cell.lastMessage?.text = chats[indexPath.row].timestamp
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)

        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        return cell*/

    }
    
    func tableView(_ collectionView: UITableView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        self.indexPressedCell = indexPath.row
        self.performSegue(withIdentifier: "chatLog", sender: self)
    }
}



































