//
//  ViewController.swift
//  ReproductorMusical
//
//  Created by Jose Luis Garcia Dueñas on 11/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Darwin

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode = UIViewContentMode.ScaleAspectFill
                if data == nil {
                    
                } else {
                    self.image = UIImage(data: data!)
                }
            }
            }.resume()
    }
}

class ViewController: UIViewController,
UIPickerViewDataSource, UIPickerViewDelegate {
    
    var resultado: String!
    var arrayCanciones: Array<Array<String>> = Array<Array<String>>()
    var ShuffleActivo: Bool!
    private var reproductor: AVAudioPlayer!
    

    @IBOutlet weak var TituloCancion: UILabel!
    @IBOutlet weak var ImagenPortada: UIImageView!
    @IBOutlet weak var ListaCanciones: UIPickerView!


    @IBAction func Play() {
        if reproductor == nil {
            CargarTitulo(arrayCanciones[0][2])
            CargarCancion(arrayCanciones[0][0])
            CargarImagen(arrayCanciones[0][1])
        } else {
            if !reproductor.playing{
                reproductor.play()
            }
        }
     }
    

    @IBAction func Volumen(sender: UISlider) {
        if reproductor == nil {
        } else {
            reproductor.volume = sender.value
            print(sender.value)
        }
    }

    @IBAction func Pause() {
        if reproductor == nil {
        } else {
              if reproductor.playing{
                 reproductor.pause()
              }
        }
    }
    

    @IBAction func Stop() {
        if reproductor == nil {
        } else {
            if reproductor.playing{
                reproductor.stop()
                reproductor.currentTime = 0.0
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ListaCanciones.dataSource = self;
        self.ListaCanciones.delegate = self;

        // Do any additional setup after loading the view, typically from a nib.
        ImagenPortada.sizeToFit()

        cargarCanciones()

    }
    
    func cargarCanciones() {
        arrayCanciones.append(["Clocks", "clocks.jpg", "Clocks"])
        arrayCanciones.append(["Country House ", "Country.jpg", "Country House"])
        arrayCanciones.append(["Enjoy the Silence", "Enjoy.jpg", "Enjoy the Silence"])
        arrayCanciones.append(["Lessons in Love", "lessons.jpg", "Lessons in Love"])
        arrayCanciones.append(["Porcelain", "porcelain.jpg", "Porcelain"])
        arrayCanciones.append(["Relax", "relax.jpg", "Relax", "Relax, Take It Easy"])
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCanciones.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ShuffleActivo = false
        return arrayCanciones[row][0]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if ShuffleActivo == true {
        } else {
           CargarTitulo(arrayCanciones[row][2])
           CargarCancion(arrayCanciones[row][0])
           CargarImagen(arrayCanciones[row][1])
        }
     }

    func CargarCancion(cancion: String) {
        let sonidoURL = NSBundle.mainBundle().URLForResource(cancion, withExtension: "mp3")
        do {
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            if !reproductor.playing{
                reproductor.play()
            } else {
                reproductor.stop()
                reproductor.currentTime = 0.0
                reproductor.play()
            }

    
        } catch {
            print("Error al cargar el archivo de audio")
    
        }
    }
    
    func CargarImagen(imagen: String) {
        let image = UIImage(named: imagen)
        ImagenPortada.image = image
        ImagenPortada.sizeToFit()
    }
    
    func CargarTitulo(Titulo:String) {
        TituloCancion.text = Titulo
    }
    
    func ShuffleCambia() {
        let indice: Int = random() % 6
        ShuffleActivo = true
        CargarTitulo(arrayCanciones[indice][2])
        CargarCancion(arrayCanciones[indice][0])
        CargarImagen(arrayCanciones[indice][1])
        self.ListaCanciones.selectRow(indice, inComponent: 0, animated: true)
        self.pickerView(self.ListaCanciones, didSelectRow: 0, inComponent: 0)
    }
    
    @IBAction func BotonShuffle() {
        ShuffleCambia()
    }

    
  }
