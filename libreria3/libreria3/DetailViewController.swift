//
//  DetailViewController.swift
//  libreria3
//
//  Created by Jose Maria Fernandez on 8/10/16.
//  Copyright © 2016 Universidad de Alicante. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var buscador: UISearchBar!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!

    var search: Bool = false
    var detailItem: Libro? = nil
    let direccion = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    var contexto : NSManagedObjectContext?
    
    func configureView() {
        if let detail = self.detailItem {
            if let label = self.titulo {
                label.text = detail.titulo!.description
            }
            if let label = self.autores {
                label.text = detail.autores!.description
            }
            if let image = self.portada {
                if detail.portada != "" {
                let url = URL(string: detail.portada!)
                    image.downloadedFrom(url: url! )
                }
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        buscador.delegate = self
        
        if search {
            self.buscador.isHidden = false
            titulo.text = ""
            autores.text = ""
            //portada.removeFromSuperview()
            self.title = "Buscar"
        }
        else{
            self.buscador.isHidden = true
            self.configureView()
            self.title = "Detalles"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("adi¡uis")
        obtenerDatos()
        self.buscador.endEditing(true)
    }

    func obtenerDatos() -> Void {
        
        let bloque = { (datos: Data?, respuesta: URLResponse?, error: Error?) -> Void in
            
            if let _ = error {
                
                let alert = UIAlertController(title: "Error", message: "No se ha podido establecer la conexión.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else {
                
                let codigo = "ISBN:\(self.buscador.text!)"
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
                        var url2 : String?
                        
                        if let dict3 = dict2["cover"] {
                            let dictCover = dict3 as! NSDictionary
                            let urls = dictCover["large"] as? String
                            url2 = urls!
                            
                            let url = URL(string: urls!)
                            self.portada.downloadedFrom(url: url! )
                            
                        }else {
                            DispatchQueue.main.sync() {
                                self.portada.removeFromSuperview()
                            }
                        }
                       
                        self.insertarLibro(t: tituloTemporal, a: autoresTemporales, p: url2! )
                        
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
        
        let url = URL(string: direccion + self.buscador.text!)
        let session = URLSession.shared
        let dt = session.dataTask(with: url!, completionHandler: bloque)
        dt.resume()
        
    }


    func insertarLibro(t : String, a : String, p : String) {
        
        let newLibro = Libro(context: contexto!)
        
        newLibro.titulo = t
        newLibro.autores = a
        newLibro.portada = p
        
        // Save the context.
        do {
            try contexto!.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
}
