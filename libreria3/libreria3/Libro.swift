//
//  Libros.swift
//  libreria3
//
//  Created by Jose Maria Fernandez on 8/10/16.
//  Copyright © 2016 Universidad de Alicante. All rights reserved.
//

import Foundation

class Libro {
    var titulo : String
    var autores : String
    var portada : String
    
    init(t : String, a : String, p : String){
        self.titulo = t
        self.autores = a
        self.portada = p
    }
}
