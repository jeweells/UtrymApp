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
    //var chats = [ChatMessage]()
    //var messDict = [String: ChatMessage]()
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?
    var indexPressedCell: Int = 0
    let currentLog = Auth.auth().currentUser?.uid
    @IBOutlet weak var chatsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatsTable.rowHeight = 71
        // remove separators for empty cells
        chatsTable.tableFooterView = UIView()
        self.chatsTable.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
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
            let messageId = snapshot.key
            Database.database().reference().child("chats-messages").child(messageId).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any]
                {
                    let enviadoPor = dict["enviadoPor"] as! String
                    let recibidoPor = dict["recibidoPor"] as! String
                    let hora = dict["hora"] as! NSNumber
                    let mensaje = dict["mensaje"] as! String
                    let chat = ChatNew(enviadoPorText: enviadoPor, recibidoPorText: recibidoPor, horaInt: hora, mensajeText: mensaje)
                    // Necesito que lea todos los mensajes para que muestre el más reciente ya sea recibido o enviado
                    // Pero solo necesito que cree celdas con chats1.count para los ids diferentes del current user
                    //if let est = chat.recibidoPor {
                    //self.messDict1[est] = chat
                    let receptor = chat.recibidoPor
                    self.messDict1[receptor] = chat
                    self.chats1 = Array(self.messDict1.values)
                    self.chats1.sort(by: { (message1, message2) -> Bool in
                        return message1.hora.intValue > message2.hora.intValue
                    })
                    //}
                }
                self.chatsTable.reloadData()
            })
        }
        ref.removeAllObservers()
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ChatLogClientController {
            print("Inicé chat con: \(chats1[indexPressedCell].enviadoPor)")
            //Siempre envía el id del cliente logueado
            destinationController.estilistID = chats1[indexPressedCell].enviadoPor
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
        let estilistID = mensaje.recibidoPor
        let ref = Database.database().reference()
        ref.child("estilistas").child((estilistID)).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                cell.titleMessage?.text = "\(nombreText) \(apellidoText)"
            }
        })
        ref.removeAllObservers()
        
        //cell.titleMessage?.text = mensaje.recibidoPor
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

    }
    
    func tableView(_ collectionView: UITableView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        self.indexPressedCell = indexPath.row
        self.performSegue(withIdentifier: "chatLog", sender: self)
    }
}



































