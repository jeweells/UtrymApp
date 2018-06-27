//
//  ListEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 22/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ListEstilistController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "barra_superior_dark.png"), for: .default)
        let backgroundImage = UIImage(named: "Background_list_estilist.png")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
    }
}

    extension ListEstilistController: UICollectionViewDataSource {
        func collectionView(_ collectionService: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //return categorys.count
            return 10
        }
        
        func collectionView(_ collectionService: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionService.dequeueReusableCell(withReuseIdentifier: "EstilistSearchCell", for: indexPath) as! EstilistSearchCell
            //cell.nameServices?.text = categorys[indexPath.row].nombre
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
    
    
    extension ListEstilistController: UICollectionViewDelegateFlowLayout {
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

