//
//  ViewController.swift
//  libreria
//
//  Created by Jose Maria Fernandez on 24/9/16.
//  Copyright © 2016 Universidad de Alicante. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    
    let direccion = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        obtenerDatos()
        return true
    }
    
    func obtenerDatos() -> Void {
        
        let bloque = { (datos: Data?, respuesta: URLResponse?, error: Error?) -> Void in
            
            if let _ = error {
                
                let alert = UIAlertController(title: "Error", message: "No se ha podido establecer la conexión.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else {
        
                let codigo = "ISBN:\(self.isbn.text!)"
                var tituloTemporal = ""
                var autoresTemporales = ""
            
                do {
                    let json = try JSONSerialization.jsonObject(with: datos!, options: .mutableLeaves)
                    let dict1 = json as! NSDictionary
                    //let dict2 = dict1[codigo] as! NSDictionary
                    if let dictx = dict1[codigo] {
                        let dict2 = dictx as! NSDictionary
                        tituloTemporal = (dict2["title"] as? String)!
                
                        let autores = dict2["authors"] as! NSArray as Array
                        for a in autores {
                            autoresTemporales += (a["name"] as? String)!
                        }
                
                        if let dict3 = dict2["cover"] {
                            let dictCover = dict3 as! NSDictionary
                            let urls = dictCover["large"] as? String
                    
                            let url = URL(string: urls!)
                            self.portada.downloadedFrom(url: url! )
                    
                        }else {
                            DispatchQueue.main.sync() {
                                self.portada.removeFromSuperview()
                            }
                        }
                
                        DispatchQueue.main.sync() {
                            self.titulo.text = tituloTemporal
                            self.autores.text = autoresTemporales
                        }
                        
                    }else{
                        let alert = UIAlertController(title: "Info", message: "No hay resultados.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                
                } catch {
                
                }
            
            }
            
        }
        
        let url = URL(string: direccion + self.isbn.text!)
        let session = URLSession.shared
        let dt = session.dataTask(with: url!, completionHandler: bloque)
        dt.resume()
        
    }
    
}


