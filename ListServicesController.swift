//
//  ListServicesController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 9/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ListServicesController: UIViewController {

    @IBOutlet weak var listServCollectionView: UICollectionView!
    
    var nombreCat: String = ""
    var services = [Service]()
    var listServices = [Service]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadServices()
        
        self.listServCollectionView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadServices() {
        // algo aqui no funciona, no se muestra lo que quiero
        //let ref = Database.database().reference().child("servicios")
        //let query = ref.queryOrdered(byChild: "categoria").queryEqual(toValue: nombreCat)
        //query.observe(.value) { (snapshot: DataSnapshot) in
        let ref = Database.database().reference()
        //ref.observe(.value) { (snapshot: DataSnapshot) in
        ref.child("servicios").observe(.childAdded) { (snapshot: DataSnapshot) in
        //    for childSnapshot in snapshot.children {
        //        print(childSnapshot)
            
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["nombre"] as! String
                let precioText = dict["precio"] as! String
                let categoText = dict["categoria"] as! String
                let service = Service(nombreText: nombreText, precioText: precioText, categoText: categoText)
                self.services.append(service)
                print(self.services)
                self.listServCollectionView.reloadData()
            }
          //  }
        }
        ref.removeAllObservers()
    }
    
}

extension ListServicesController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(services.count)
        return services.count
        //return 10
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ListServicesCell", for: indexPath) as! ListServicesCell
        cell.nameService?.text = services[indexPath.row].nombre
        cell.priceService?.text = services[indexPath.row].precio
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let backgroundImage = UIImage(named: "list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        /*cell.nameService?.text = services[indexPath.row].nombre
        cell.estilistID = estilists[indexPath.row].uid
         */
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        //self.indexPressedCell = indexPath.row
        //self.performSegue(withIdentifier: "listServices", sender: self)
    }
}

extension ListServicesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 55)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
