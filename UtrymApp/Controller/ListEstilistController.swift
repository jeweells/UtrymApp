//
//  ListEstilistController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 22/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ListEstilistController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        profileTapped()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems(){
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "Logo_inter"))
        navigationItem.titleView = titleImageView
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "Mask_avatar").withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height:34)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    @objc func profileTapped(){
        //show(ProfileEstilistController(), sender: self)
    }
    
}
