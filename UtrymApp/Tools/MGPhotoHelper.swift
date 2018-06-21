//
//  MGPhotoHelper.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 20/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    // MARK: - Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    func presentActionSheet(from viewController: UIViewController) {
        // 1
        let alertController = UIAlertController(title: nil, message: "De dónde deseas elegir la imagen?", preferredStyle: .actionSheet)
        
        // 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let capturePhotoAction = UIAlertAction(title: "Tomar una Foto", style: .default, handler: { [unowned self] action in
                    self.presentImagePickerController(with: .camera, from: viewController)
                })
                
                alertController.addAction(capturePhotoAction)
            }
            
            // 3
            /*let capturePhotoAction = UIAlertAction(title: "Tomar una Foto", style: .default, handler: { action in
                // do nothing yet...
            })
            
            // 4
            alertController.addAction(capturePhotoAction)*/
        }
        
        // 5
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let uploadAction = UIAlertAction(title: "Descargar desde la Librería", style: .default, handler: { [unowned self] action in
                    self.presentImagePickerController(with: .photoLibrary, from: viewController)
                })
                
                alertController.addAction(uploadAction)
            }
            /*let uploadAction = UIAlertAction(title: "Descargar desde la Librería", style: .default, handler: { action in
                // do nothing yet...
            })
            
            alertController.addAction(uploadAction)*/
        }
        
        // 6
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 7
        viewController.present(alertController, animated: true)
    }
    
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        
        viewController.present(imagePickerController, animated: true)
    }
}
