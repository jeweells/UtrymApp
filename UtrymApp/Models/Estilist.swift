//
//  Estilist.swift
//  UtrymApp
//
//  Created by Alexis Barniquez on 13/6/18.
//  Copyright © 2018 Alexis Barniquez. All rights reserved.
//

import Foundation
class Estilist {
    
    var uid: String
    var nombre: String
    var apellido: String
    var url: String
    
    init(nombreText: String, apellidoText: String, urlText: String, estiID: String) {
        uid = estiID
        nombre = nombreText
        apellido = apellidoText
        url = urlText
    }
}
