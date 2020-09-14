//
//  SecondViewController.swift
//  Challenge4
//
//  Created by Sahil Satralkar on 14/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var imageFullView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    
    var imageDataArraySVC = [ImageData]()
    var indexRow = Int()
    
    
    //Create UserDefaults object
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempImageData = imageDataArraySVC[indexRow]
        let path = getDocumentsDirectory().appendingPathComponent(tempImageData.imageFileName)
        if let imageToLoad = UIImage(contentsOfFile: path.path) {
            imageFullView.image  = imageToLoad
            // title is the keyword to assign title label text in the Navigation bar at top
            title = tempImageData.imageCellName
            captionLabel.text = tempImageData.caption
        }
        //To disable the large Navigation bar text label
        navigationItem.largeTitleDisplayMode = .never
        
        
        
        
        //Try code
        
        imageFullView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageFullView.addGestureRecognizer(tapRecognizer)
        
        
    }
    
    @objc func imageTapped() {
        
        let ac = UIAlertController(title: "Add Caption", message: "Please enter caption for the image", preferredStyle: .alert)
        ac.addTextField()
        //let action = UIAlertAction(title: "OK", style: .default)
        //ac.addAction(action)
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac] _ in
            guard let newCaption = ac?.textFields?[0].text else { return }
            self?.captionLabel.text = newCaption
            self?.imageDataArraySVC[self!.indexRow].caption = newCaption
            //Save method called before reload
            self?.save()
            
            
            
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
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
