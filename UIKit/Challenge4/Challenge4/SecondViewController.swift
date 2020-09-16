//
//  SecondViewController.swift
//  Challenge4
//
//  Created by Sahil Satralkar on 14/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    //IBOutlets are defined
    @IBOutlet var imageFullView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    
    //Variables declaration
    var imageDataArraySVC = [ImageData]()
    var indexRow = Int()
    
    //Create UserDefaults object
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the ImageData object for the selected row.
        let tempImageData = imageDataArraySVC[indexRow]
        //Get path for the documents directory.
        let path = getDocumentsDirectory().appendingPathComponent(tempImageData.imageFileName)
        //Assign image and caption to IBOutkets
        if let imageToLoad = UIImage(contentsOfFile: path.path) {
            imageFullView.image  = imageToLoad
            // title is the keyword to assign title label text in the Navigation bar at top
            title = tempImageData.imageCellName
            captionLabel.text = tempImageData.caption
        }
        //To disable the large Navigation bar text label
        navigationItem.largeTitleDisplayMode = .never
        
        //Userinteraction on image enable to show alert to user for caption
        imageFullView.isUserInteractionEnabled = true
        //User tap is detected and stored. Selector function is called.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageFullView.addGestureRecognizer(tapRecognizer)
        
        
    }
    
    //Selector function is called when the image is tapped
    @objc func imageTapped() {
        
        //New alert is shown
        let ac = UIAlertController(title: "Add Caption", message: "Please enter caption for the image", preferredStyle: .alert)
        //Add cancel action to UIAlertController
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //Add textfield to UIAlertController
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac] _ in
            guard let newCaption = ac?.textFields?[0].text else { return }
            //textfield value is set to Caption label on image.
            self?.captionLabel.text = newCaption
            //Caption text also set in array to save it in UserDefaults.
            self?.imageDataArraySVC[self!.indexRow].caption = newCaption
            //Save method called before reload
            self?.save()
            
        })
        
        //Present the alert
        present(ac, animated: true)
        
    }
    
    //Custom function to get file path url from filemanager.
    func getDocumentsDirectory () -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return path[0]
        return paths[0]
        
    }
    
    //Save function will Encode people with JSONEncode before saving it to UserDefaults
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(imageDataArraySVC) {
            defaults.set(savedData, forKey: "ImageDataArray")
        } else {
            print("Failed to save ImageDataArray")
        }
    }
    
    
    
    
}
