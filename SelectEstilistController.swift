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
    var indexPressedCell: Int = 0

    @IBOutlet weak var selectEstilist: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectEstilist.backgroundColor = UIColor.clear
        
        loadEstilists()
        //fetchEst ()
    }

    func loadEstilists() {
        let ref = Database.database().reference()
        ref.child("estilistas").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let estiID = dict["uid"] as! String
                let especialidad = dict["especialidqad"] as! String
                let estilist = Estilist(nombreText: nombreText, apellidoText: apellidoText, urlText: urlText, estiID: estiID, especialidad: especialidad)
                self.estilists.append(estilist)
                print(self.estilists)
                
                self.selectEstilist.reloadData()
            }
        }
        ref.removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? NewMessageController {
            print("Inicé chat con: \(estilists[indexPressedCell].uid)")
            destinationController.estilistID = estilists[indexPressedCell].uid
        }
    }
    
    /*func fetchEst () {
        //let estilist = "sjefuaehiuf"
        //Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
        let ref = Database.database().reference().child("users")
        let query = ref.queryOrdered(byChild: "id_perfil").queryEqual(toValue: "sjefuaehiuf")
        query.observe(.value, with: { (snapshot) in
            /*for childSnapshot in snapshot.children {
                print(childSnapshot)
            }*/
            print(snapshot.children)
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["nombre"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlToImage"] as! String
                let estiID = dict["uid"] as! String
                let estilist = Estilist(nombreText: nombreText, apellidoText: apellidoText, urlText: urlText, estiID: estiID)
                self.estilists.append(estilist)
                print(self.estilists)
                self.selectEstilist.reloadData()
            }
        })
        ref.removeAllObservers()
    }*/
    
}

extension SelectEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return estilists.count
        //return 10
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "SelectEstilistCell", for: indexPath) as! SelectEstilistCell
        cell.nombreEstilist?.text = estilists[indexPath.row].nombre
        cell.apellidoEstilist?.text = estilists[indexPath.row].apellido
        cell.imageEstilist.downloadImageEst(from: self.estilists[indexPath.row].url)
        cell.estilistID = estilists[indexPath.row].uid
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let backgroundImage = UIImage(named: "list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //dismiss (animated: true){
        print("User tapped on item \(indexPath.row)")
        self.indexPressedCell = indexPath.row
        self.performSegue(withIdentifier: "new", sender: self)
        //}
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


extension UIImageView {
    func downloadImageEst(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
}
