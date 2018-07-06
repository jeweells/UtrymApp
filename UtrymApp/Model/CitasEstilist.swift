//
//  CitasEstilist.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 5/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation

class CitasEstilist {
    
    var fecha: String
    var time: String
    var cliente: String
    
    init(fechaText: String, clienteString: String, timeText: String) {
        fecha = fechaText
        time = timeText
        cliente = clienteString
    }
}

