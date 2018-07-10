//
//  ChatsListClientController.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatsListClientController: UIViewController {
    
    var chats = [ChatNew]()
    
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?

    @IBOutlet weak var chatsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatsTable.rowHeight = 71
        // remove separators for empty cells
        chatsTable.tableFooterView = UIView()
        
        
        userChatsHandle = UserService.observeChats { [weak self] (ref, chats) in
            self?.userChatsRef = ref
            self?.chats = chats
            DispatchQueue.main.async {
                self?.chatsTable.reloadData()
            }
        }
    }

    deinit {
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ChatsListClientController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListClientCell") as! ChatListClientCell
        
        let chat = chats[indexPath.row]
        cell.titleMessage.text = chat.title
        cell.lastMessage.text = chat.lastMessage
        
        return cell
    }
}
