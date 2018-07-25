//
//  MGPhotoHelper.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 20/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    
    var completionHandler: ((UIImage) -> Void)?
    
    func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "De dónde deseas elegir la imagen?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let capturePhotoAction = UIAlertAction(title: "Tomar una Foto", style: .default, handler: { [unowned self] action in
                    self.presentImagePickerController(with: .camera, from: viewController)
                })
                
                alertController.addAction(capturePhotoAction)
            }
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let uploadAction = UIAlertAction(title: "Descargar desde la Librería", style: .default, handler: { [unowned self] action in
                    self.presentImagePickerController(with: .photoLibrary, from: viewController)
                })
                
                alertController.addAction(uploadAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        viewController.present(imagePickerController, animated: true)
    }
}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
