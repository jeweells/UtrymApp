//
//  EstilistTabBarController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 19/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EstilistTabBarController: UITabBarController {
    let photoHelper = MGPhotoHelper()
    //let photoHelper = AttachmentHandler()
    let myPickerController = UIImagePickerController()
    let dateFormatter = ISO8601DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //myPickerController.delegate = self
        myPickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        /*
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            PostService.create(for: image)
            
        }
        // no se como subir el videooooooooo
        
         AttachmentHandler.shared.videoPickedBlock = { (videoUrl) in
         PostService.create(for: videoUrl)
         
         }
         */
        
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }
        
        
        
        delegate = self
        tabBar.unselectedItemTintColor = .black
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                tabBar.backgroundImage = UIImage(named: "Barra inferior 1")
            default:
                tabBar.backgroundImage = UIImage(named: "Barra inferior")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension EstilistTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self)
            //photoHelper.showAttachmentActionSheet(vc: self)
            return false
        }
        return true
    }
}

