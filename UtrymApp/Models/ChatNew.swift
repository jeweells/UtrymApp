//
//  ChatNew.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 10/7/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ChatNew {
    var cliente: String
    var estilista: String
    var hora: NSNumber
    var mensaje: String
    var leidoCli: Bool = false
    var leidoEst: Bool = false
    
    init(clienteText: String, estilistaText: String, horaInt: NSNumber, mensajeText: String) {
        cliente = clienteText
        estilista = estilistaText
        hora = horaInt
        mensaje = mensajeText
    }
}
