//
//  ChatService.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ChatService {
    
    // Creating New Chats
    static func create(from message: Message, with chat: ChatNew, completion: @escaping (ChatNew?) -> Void) {
        
        var membersDict = [String : Bool]()
        for uid in chat.memberUIDs {
            membersDict[uid] = true
        }
        
        let lastMessage = "\(message.sender.username): \(message.content)"
        chat.lastMessage = lastMessage
        let lastMessageSent = message.timestamp.timeIntervalSince1970
        chat.lastMessageSent = message.timestamp

        let chatDict: [String : Any] = ["title" : chat.title,
                                        "memberHash" : chat.memberHash,
                                        "members" : membersDict,
                                        "lastMessage" : lastMessage,
                                        "lastMessageSent" : lastMessageSent]

        let chatRef = Database.database().reference().child("chats").child(UserNew.current.uid).childByAutoId()
        chat.key = chatRef.key

        var multiUpdateValue = [String : Any]()

        for uid in chat.memberUIDs {
            multiUpdateValue["chats/\(uid)/\(chatRef.key)"] = chatDict
        }

        let messagesRef = Database.database().reference().child("messages").child(chatRef.key).childByAutoId()
        let messageKey = messagesRef.key
        
        multiUpdateValue["messages/\(chatRef.key)/\(messageKey)"] = message.dictValue

        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            completion(chat)
        }
    }
    
    // Checking for Existing Chats
    static func checkForExistingChat(with user: UserNew, completion: @escaping (ChatNew?) -> Void) {
        let members = [user, UserNew.current]
        let hashValue = ChatNew.hash(forMembers: members)

        let chatRef = Database.database().reference().child("chats").child(UserNew.current.uid)

        let query = chatRef.queryOrdered(byChild: "memberHash").queryEqual(toValue: hashValue)

        query.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let chatSnap = snapshot.children.allObjects.first as? DataSnapshot,
                let chat = ChatNew(snapshot: chatSnap)
                else { return completion(nil) }
            
            completion(chat)
        })
    }
    
    
    // Sending Messages in a Chat
    static func sendMessage(_ message: Message, for chat: ChatNew, success: ((Bool) -> Void)? = nil) {
        guard let chatKey = chat.key else {
            success?(false)
            return
        }
        
        var multiUpdateValue = [String : Any]()
        
        for uid in chat.memberUIDs {
            let lastMessage = "\(message.sender.username): \(message.content)"
            multiUpdateValue["chats/\(uid)/\(chatKey)/lastMessage"] = lastMessage
            multiUpdateValue["chats/\(uid)/\(chatKey)/lastMessageSent"] = message.timestamp.timeIntervalSince1970
        }
        
        let messagesRef = Database.database().reference().child("messages").child(chatKey).childByAutoId()
        let messageKey = messagesRef.key
        multiUpdateValue["messages/\(chatKey)/\(messageKey)"] = message.dictValue
        
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue, withCompletionBlock: { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success?(false)
                return
            }
            
            success?(true)
        })
    }
    
    
    // Observing User's Chats
    static func observeChats(for user: UserNew = UserNew.current, withCompletion completion: @escaping (DatabaseReference, [ChatNew]) -> Void) -> DatabaseHandle {
        let ref = Database.database().reference().child("chats").child(user.uid)
        
        return ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion(ref, [])
            }
            
            let chats = snapshot.compactMap(ChatNew.init)
            completion(ref, chats)
        })
    }
    
    
    // Observing Chat Messages
    static func observeMessages(forChatKey chatKey: String, completion: @escaping (DatabaseReference, Message?) -> Void) -> DatabaseHandle {
        let messagesRef = Database.database().reference().child("messages").child(chatKey)
        
        return messagesRef.observe(.childAdded, with: { snapshot in
            guard let message = Message(snapshot: snapshot) else {
                return completion(messagesRef, nil)
            }
            
            completion(messagesRef, message)
        })
    }
    
    
    
}
