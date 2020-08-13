//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Sahil Satralkar on 12/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //IBOutlet for Flag display image.
    @IBOutlet var flagImage: UIImageView!
    //Variable to store the selected file name
    var selectedImage : String?
    //Variable to store the flag name
    var flagName = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If let condition to avoid null error.
        if let imageToDisplay = selectedImage {
            flagImage.image = UIImage(named: imageToDisplay)
            //This logic to remove the @2x suffix from flag name.
            for c in imageToDisplay {
                if c == "@" {
                    break
                } else {
                    flagName.append(c)
                }
            }
        }
        
        // flag name is coverted to Upper case before assigning to navigation bar title text.
        title = flagName.uppercased()
        //Default implementation to keep the navigation bar text small on this screen.
        navigationItem.largeTitleDisplayMode = .never
        //Code will create a button on the right side of Navigation bar. This is to enable sharing of the image.
        //New UIBarButtonItem instance is created. barButtonSystemItem is chosen as the in-built action button image. trget parameter is self because the
        //function to be called is within self class. action parameter is given #selector which again contains the method to be called on button clicked.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        
    }
    
    //@objc annotation is mandatry because #selector is a objective C code.
    @objc func shareButtonTapped() {
        
        //the image is downgraded to 80% quality to save space with the jpegData method.
        guard let image = flagImage.image?.jpegData(compressionQuality: 0.8) else {
            print("Image not found")
            return
        }
        
        //New UIActivityViewController object is created. The image is passed inside the activityItems array.
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        //This implementation is necessary for iPad
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        //Present the UIActivityViewController object.
        present(avc, animated: true)
        
    }
    
}
