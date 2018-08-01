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
    var enviadoPor: String
    var recibidoPor: String
    var hora: NSNumber
    var mensaje: String
    var leidoCli: Bool = false
    var leidoEst: Bool = false
    
    init(enviadoPorText: String, recibidoPorText: String, horaInt: NSNumber, mensajeText: String) {
        enviadoPor = enviadoPorText
        recibidoPor = recibidoPorText
        hora = horaInt
        mensaje = mensajeText
    }
}
