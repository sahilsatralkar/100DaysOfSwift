//
//  ViewController.swift
//  Project13
//
//  Created by Sahil Satralkar on 16/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//
//Import CoreImage to enable Apple inbuilt tools for Image editing.
//Layut constraints done with 'Reset to suggested constraints'.
//
import CoreImage
import UIKit

//To use image picker, use the UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols on class
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Declare the IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var changeFilterLabel: UIButton!
    @IBOutlet var radius: UISlider!
    @IBOutlet var scale: UISlider!
    @IBOutlet var center: UISlider!
    
    //Declare the variables
    var currentImage : UIImage!
    var context : CIContext!
    var currentFilter : CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.alpha = 0
        
        
        
        //Set Navigation bar title
        title = "InstaFilter"
        //Add right bar button on navigation bar with selector action
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        //Create new Core Image context and add default sepia filter to CIFilter object.
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        changeFilterLabel.setTitle("CISepiaTone", for: .normal)
    }
    
    //Selector function for Nav bar button.
    @objc func importPicture(){
        // Create picker objet and present
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        //Assign picker object to self
        picker.delegate = self
        //present picker
        present(picker, animated: true)
    }
    
    
    //function from UIImagePickerControllerDelegate protocol. Called internally by picker.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Get the image out safely with guard
        guard let image = info[.editedImage] as? UIImage else { return }
        //dismiss picker
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing(tag: nil)
        
    }
    
    //IBAction for the change button to change the filters.
    //Add different effects with actionSheet style
    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    //Common handler function fot any filter selected from ChangeFilter actionSheet.
    @objc func setFilter(action : UIAlertAction){
        // make sure we have a valid image before continuing!
        changeFilterLabel.setTitle(action.title, for: .normal)
        
        guard currentImage != nil else { return }
        
        // safely read the alert action's title
        guard let actionTitle = action.title else { return }
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing(tag: nil)
    }
    
    //Function to save image on iphone/ipad storage
    @IBAction func save(_ sender: UIButton) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
            
        else {
            
            let ac = UIAlertController(title: "Save error", message: "No image selected to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        
        applyProcessing(tag : sender.tag)
    }
    
    //Function to do image processing based on effect selected and value of slider.
    //each slider is given unique tag number from 0 to 3.
    func applyProcessing(tag : Int?){
        
        let inputKeys = currentFilter.inputKeys
        
        switch tag {
        case 0:
            //
            if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
        case 1:
            //
            if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey) }
        case 2:
            //
            if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        case 3:
            //
            if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        default:
            //
            print("Default switch case")
        }
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
        imageView.alpha = 1

    }
    
    //Selector function when user tries to save image. Will display appropriate alerts.
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
}

