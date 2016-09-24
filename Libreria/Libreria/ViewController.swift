//
//  ViewController.swift
//  libreria
//
//  Created by Jose Maria Fernandez on 24/9/16.
//  Copyright © 2016 Universidad de Alicante. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var resultado : String = ""
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var contenido: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbn.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func limpiarDatos(_ sender: AnyObject) {
        isbn.text = ""
        contenido.text = ""
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        obtenerDatos()
        return true
    }
    
    func obtenerDatos() -> Void {
        let direccion = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = URL(string: direccion + self.isbn.text!)
        
        let session = URLSession.shared
        let bloque = { (datos: Data?, respuesta: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.sync() {
                if let _ = error {
                    self.contenido.text = "Ha ocurrido un error con la conexión y no se han podido obtener los datos."
                } else {
                    let valor = String(data:datos!,encoding: .utf8)!                    
                    self.contenido.text = valor
                }
            }
        }
        
        let dt = session.dataTask(with: url!, completionHandler: bloque)
        dt.resume()
    }
    
}

