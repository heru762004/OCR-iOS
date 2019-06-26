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
            if let img2 = imageView.image {
                imageView.image = img2.scaledImage(1000) ?? img2
            }
        }
    }
    
    @IBAction func processImage(_ sender: Any) {
        showLoading()
        // 1
        if let tesseract = G8Tesseract(language: "eng") {
            // 2
            tesseract.engineMode = .tesseractCubeCombined
            // 3
            tesseract.pageSegmentationMode = .auto
            // 4
            tesseract.image = self.imageView.image
            DispatchQueue.global().async() {
                
                // 5
                tesseract.recognize()
                // 6
                DispatchQueue.main.async{
                    print("recognized text = \(tesseract.recognizedText)")
                    self.dismiss(animated: true, completion: {
                        if let message = tesseract.recognizedText {
                            self.showAlert(message: message)
                        }
                    })
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            //                self.storeDataToDB(keyValue: "0", keyName: self.IS_REGISTERED)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}

