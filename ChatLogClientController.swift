//
//  ChatLogClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 15/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit

class ChatLogClientController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatArea: UIView!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var estilistID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = UIColor.clear
    }



}
