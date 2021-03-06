//
//  ListEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 22/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ListEstilistController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var estilists = [Estilist]()
    var ref : DatabaseReference!
    var indexPressedCell: Int = 0
    var myString:NSString = ""
    var myMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEstilists()
        setupNavigationBarItems()
        self.collectionView.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "barra_superior_dark.png"), for: .default)
        //let backgroundImage = UIImage(named: "Background_list_estilist.png")
        //let imageView = UIImageView(image: backgroundImage)
        //self.collectionView.backgroundView = imageView
        //imageView.contentMode = .scaleAspectFill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Setting_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    @objc func profileTapped(){
        self.performSegue(withIdentifier: "profileClientSearch", sender: self)
    }
    
    func loadEstilists() {
        let ref = Database.database().reference()
        ref.child("estilistas").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["name"] as! String
                let apellidoText = dict["apellido"] as! String
                let urlText = dict["urlAvatar"] as! String
                let estiID = dict["uid"] as! String
                let esp = dict["especialidad"] as! String
                let estilist = Estilist(nombreText: nombreText, apellidoText: apellidoText, urlText: urlText, estiID: estiID, especialidad: esp)
                self.estilists.append(estilist)
                //print(self.estilists)
                
                self.collectionView.reloadData()
            }
        }
        ref.removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ProfileEstilistClientController {
            print("Me fui a ver el perfil: \(estilists[indexPressedCell].uid)")
            destinationController.estilistID = estilists[indexPressedCell].uid
        }
    }
}

extension ListEstilistController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return estilists.count
        //return 10
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "EstilistSearchCell", for: indexPath) as! EstilistSearchCell
        cell.nameEstilist?.text = "\(estilists[indexPath.row].nombre) \(estilists[indexPath.row].apellido)"
        cell.avatarEstilist.downloadImage(from: self.estilists[indexPath.row].url)
        cell.estilistID = estilists[indexPath.row].uid
        cell.especialidad?.text = estilists[indexPath.row].esp
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
        print("User tapped on item \(indexPath.row)")
        self.indexPressedCell = indexPath.row
        self.performSegue(withIdentifier: "profileEst", sender: self)
    }
}

    
    
extension ListEstilistController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 73)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

