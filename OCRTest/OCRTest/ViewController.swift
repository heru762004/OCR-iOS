//
//  ViewController.swift
//  OCRTest
//
//  Created by Heru Prasetia on 26/6/19.
//  Copyright © 2019 NETS. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        if let img = imageView.image {
            imageView.image = img.fixedOrientation()
        }
    }
    
    @IBAction func processImage(_ sender: Any) {
        // 1
        if let tesseract = G8Tesseract(language: "eng") {
            // 2
            tesseract.engineMode = .tesseractCubeCombined
            // 3
            tesseract.pageSegmentationMode = .auto
            // 4
            tesseract.image = imageView.image
            // 5
            tesseract.recognize()
            // 6
            print("recognized text = \(tesseract.recognizedText)")
        }
        
        
    }
    
}

