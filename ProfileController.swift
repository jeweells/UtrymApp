//
//  ProfileController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 20/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var categorysView: UICollectionView!
    @IBOutlet weak var postsView: UICollectionView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatar.layer.cornerRadius = avatar.bounds.width / 2.0
        avatar.layer.masksToBounds = true
        categorysView.delegate = self
        postsView.delegate = self
        categorysView.dataSource = self
        postsView.dataSource = self
        //self.view.addSubview(categorysView)
        //self.view.addSubview(postsView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count:Int?
        if (categorysView != nil) {
            count = 3
        }
        if (postsView != nil) {
            count = 20
        }
        return count!
    }
    
    func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if (categorysView != nil) {
            let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "CategorysCell", for: indexPath) as! CategorysCell
            //return cell
        }
        if (postsView != nil) {
            let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "ThumbCell", for: indexPath) as! ThumbCell
            //return cell
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (postsView != nil) {
            print("User tapped on item \(indexPath.row)")
            //self.indexPressedCell = indexPath.row
            //self.performSegue(withIdentifier: "listServices", sender: self)
        }

    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize: CGSize?
        
        if (postsView != nil) {
            let columns: CGFloat = 3
            let spacing: CGFloat = 1.5
            let totalHorizontalSpacing = (columns - 1) * spacing
            
            let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
            let itemSize = CGSize(width: itemWidth, height: itemWidth)
            
            //return itemSize
        }
        return itemSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if (categorysView != nil) {
            return 3
        }
        else {
            return 1.5
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if (categorysView != nil) {
            return 3
        }
        else {
            return 1.5
        }
    }
}
