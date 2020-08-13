//
//  SecondViewController.swift
//  Project 1
//
//  Created by Sahil Satralkar on 03/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    //IBoutlet for UIImageView to display photo.
    @IBOutlet var stormImage: UIImageView!
    var selectedImage: String?
    var fileNameArrayLabelSVC = [String]()
    var position = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if let condition to avoid null error.
        if let imageToLoad = selectedImage {
            //Set the image as per the selected cell.
            stormImage.image  = UIImage(named: imageToLoad)
            //title is the default implementation for Navigation bar title text.
            title = "Image \(position + 1) of \(fileNameArrayLabelSVC.count)"
        }
        
        //this code is necessay to get the small font styling for navigation bar title text.
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //this method is for the navigation bar at the top to disappear on users tap on photo.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    //this method is to keep the previous screen behavior regarding navigation bar as was earlier.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
