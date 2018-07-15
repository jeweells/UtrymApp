//
//  ChatMessage.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 14/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
class ChatMessage {
    
    var emisor: String
    var receptor: String
    var timestamp: NSNumber
    var message: String
    
    init(emisorText: String, receptorText: String, timestampInt: NSNumber, messageText: String ) {
        emisor = emisorText
        receptor = receptorText
        timestamp = timestampInt
        message = messageText
    }
}
