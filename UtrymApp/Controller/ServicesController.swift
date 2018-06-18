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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let backgroundImage = UIImage(named: "Back.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
        loadCategorys()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}


extension ServicesController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 10
        return categorys.count
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.nameServices?.text = categorys[indexPath.row].nombre
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return cell
    }
}

extension ServicesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 1
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: 100)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServiceHeaderCell", for: indexPath) as! ServiceHeaderCell
        return headerView
    }
}

