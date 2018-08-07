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
    
    var chats1 = [ChatNew]()
    var messDict1 = [String: ChatNew]()
    var chats = [ChatMessage]()
    var messDict = [String: ChatMessage]()
    var clients = [Client]()
    var ref : DatabaseReference!
    var indexPressedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        self.collectionView.backgroundColor = UIColor.clear
        setupNavigationBarItems()
        agroupChatsByClients()
        
        //let backgroundImage = UIImage(named: "Background_list_estilist.png")
        //let imageView = UIImageView(image: backgroundImage)
        //self.collectionView.backgroundView = imageView
        //imageView.contentMode = .scaleAspectFill
        
        //loadChatsUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ChatLogEstilistController {
            print("Inicé chat con: \(chats1[indexPressedCell].recibidoPor)")
            destinationController.idClient = chats1[indexPressedCell].recibidoPor
        }
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        
        /*let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "add_cita").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)*/
        
    }
    
    
    func agroupChatsByClients() {
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
                    //if let receptor = chat.recibidoPor necesito usar este if pero me da un error de String
                    let receptor = chat.recibidoPor
                    self.messDict1[receptor] = chat
                    self.chats1 = Array(self.messDict1.values)
                    print (self.chats1)
                    
                    self.chats1.sort(by: { (message1, message2) -> Bool in
                        return message1.hora.intValue > message2.hora.intValue
                    })
                }
                self.collectionView.reloadData()
            })
        }
        ref.removeAllObservers()
        
    }

}

extension ChatsEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return chats.count
        return chats1.count
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
        imageView.layer.cornerRadius = 10
        let mensaje = chats[indexPath.row]
        cell.clientFullName?.text = mensaje.emisor
        cell.textMessage?.text = mensaje.message*/
        
        let mensaje = chats1[indexPath.row]
        let clientID = mensaje.recibidoPor
        let ref = Database.database().reference()
        ref.child("clientes").child((clientID)).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["nombre completo"] as! String
                cell.clientFullName?.text = nombreText
            }
        })
        ref.removeAllObservers()
        
        
        cell.textMessage?.text = mensaje.mensaje

        let seconds = mensaje.hora.doubleValue
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
        let itemSize = CGSize(width: itemWidth, height: 70)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        self.indexPressedCell = indexPath.row
        self.performSegue(withIdentifier: "chatEstilist", sender: self)
    }
}
