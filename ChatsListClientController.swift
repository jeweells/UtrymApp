//
//  ChatsListClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatsListClientController: UIViewController {
    
    var chats = [Chat]()
    var clients = [Client]()
    
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?

    @IBOutlet weak var chatsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatsTable.rowHeight = 71
        // remove separators for empty cells
        chatsTable.tableFooterView = UIView()
        self.chatsTable.backgroundColor = UIColor.clear
        loadChats()
        /*userChatsHandle = UserService.observeChats { [weak self] (ref, chats) in
            self?.userChatsRef = ref
            self?.chats = chats
            DispatchQueue.main.async {
                self?.chatsTable.reloadData()
            }
        }*/
    }

    /*deinit {
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func loadChats() {
        
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
                    self.chatsTable.reloadData()
                }
            }
        }
        ref.removeAllObservers()
    }


}


extension ChatsListClientController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListClientCell") as! ChatListClientCell
        
        //let chat = chats[indexPath.row]
        //cell.titleMessage.text = chat.title
        //cell.lastMessage.text = chat.lastMessage
        
        cell.titleMessage?.text = clients[indexPath.row].fullName
        cell.lastMessage?.text = chats[indexPath.row].fecha
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)

        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        return cell

    }
}


