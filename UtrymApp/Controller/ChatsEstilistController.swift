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

class ChatsEstilistController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var chats = [Chat]()
    var clients = [Client]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        setupNavigationBarItems()
        /*let backgroundImage = UIImage(named: "Background_list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill*/
        loadChats()
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
                self.collectionView.reloadData()
                }
            }
        }
        ref.removeAllObservers()
    }

}

extension ChatsEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ListChatsEstilistCell", for: indexPath) as! ListChatsEstilistCell
        cell.clientFullName?.text = clients[indexPath.row].fullName
        cell.fechaChats?.text = chats[indexPath.row].fecha
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        /*let backgroundImage = UIImage(named: "list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10*/
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
