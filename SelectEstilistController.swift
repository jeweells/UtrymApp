//
//  SlelectEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 12/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectEstilistController: UIViewController {
    
    var ref: DatabaseReference!
    var estilists = [Estilist]()

    @IBOutlet weak var selectEstilist: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectEstilist.backgroundColor = UIColor.clear
        
        loadEstilists()
    }

    func loadEstilists() {
        //let ref = Database.database().reference()
        let ref = Database.database().reference().child("users")
        //ref.queryOrderedByChild("categories/Oceania").queryEqualToValue(true)
        ref.child("users").observe(.childAdded) { (snapshot: DataSnapshot) in
        //ref.queryOrdered(byChild: "id_perfil").queryEqual(toValue: "sjefuaehiuf") { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["nombre"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlToImage"] as! String
                let estiID = dict["uid"] as! String
                let estilist = Estilist(nombreText: nombreText, apellidoText: apellidoText, urlText: urlText, estiID: estiID)
                self.estilists.append(estilist)
                print(self.estilists)
                
                //self.selectEstilist.reloadData()
            }
        }
        ref.removeAllObservers()
    }

}

extension SelectEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return estilists.count
        return 10
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "SelectEstilistCell", for: indexPath) as! SelectEstilistCell
        //cell.nameEstilist?.text = estilists[indexPath.row].nombre
        //cell.apellidoEstilist?.text = estilists[indexPath.row].apellido
        //cell.avatarEstilist.downloadImageEst(from: self.estilists[indexPath.row].url)
        //cell.estilistID = estilists[indexPath.row].uid
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let backgroundImage = UIImage(named: "list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return cell
    }
}

extension SelectEstilistController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 1.5
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
