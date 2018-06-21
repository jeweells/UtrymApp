//
//  EstilistTabBarController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 19/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class EstilistTabBarController: UITabBarController {
    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabBar.unselectedItemTintColor = .white
        
        photoHelper.completionHandler = { image in
            print("handle image")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension EstilistTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            // present photo taking action sheet
            
            photoHelper.presentActionSheet(from: self)
            return false
            
            //print("take photo")

        }
        return true
    }
}

