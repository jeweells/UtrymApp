//
//  CitasEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 5/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CitasEstilistController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var citas = [CitasEstilist]()
    var clients = [Client]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Barra_superior_ligth.png"), for: .default)
        self.collectionView.backgroundColor = UIColor.clear
        loadCitas()
    }

    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "messages").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(chatsTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    @objc func chatsTapped(){
        self.performSegue(withIdentifier: "chatsEstilist", sender: self)
    }
    
    func loadCitas() {
        let ref = Database.database().reference()
        ref.child("citas").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let fechaText = dict["fecha"] as! String
                let timeText = dict["hora"] as! String
                let clienteString = dict["id_cliente"] as! String
                let cita = CitasEstilist(fechaText: fechaText, clienteString: clienteString, timeText: timeText)
                self.citas.append(cita)
                
                Database.database().reference().child("clientes").child(clienteString).observe(.value) { (snapshot: DataSnapshot) in
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension CitasEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citas.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "CitasEstilistCell", for: indexPath) as! CitasEstilistCell
        cell.titleCitas?.text = citas[indexPath.row].fecha
        cell.timeCita?.text = citas[indexPath.row].time
        cell.clienteCita?.text = clients[indexPath.row].fullName
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        return cell
    }
}


extension CitasEstilistController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 100)
        
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
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     guard kind == UICollectionElementKindSectionHeader else {
     fatalError("Unexpected element kind.")
     }
     
     let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CitasEstilistHeaderView", for: indexPath) as! CitasEstilistHeaderView
     return headerView
     }

}
