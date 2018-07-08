//
//  ServicesController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 17/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ServicesController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categorys = [Category]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        //profileTapped()

        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "barra_superior_dark.png"), for: .default)
        let backgroundImage = UIImage(named: "background_dark.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
        loadCategorys()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Utrym_Interno"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Mask_avatar").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    @objc func profileTapped(){
        //show(ProfileClientController(), sender: self)
        //self.performSegue(withIdentifier: "clientProf", sender: self)
    }
    
    func loadCategorys() {
        let ref = Database.database().reference()
        //ref.child("category").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
        ref.child("category").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let nombreText = dict["nombre"] as! String
                let category = Category(nombreText: nombreText)
                self.categorys.append(category)
                print(self.categorys)
                self.collectionView.reloadData()
            }
        }
        ref.removeAllObservers()
    }
    
}


extension ServicesController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.nameServices?.text = categorys[indexPath.row].nombre
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let backgroundImage = UIImage(named: "back_services.png")
        let imageView = UIImageView(image: backgroundImage)
        cell.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return cell
    }
}


extension ServicesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 250)
        
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
}


    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServiceHeaderCell", for: indexPath) as! ServiceHeaderCell
        return headerView
    }*/


