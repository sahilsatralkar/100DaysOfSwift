//
//  SecondViewController.swift
//  Project 1
//
//  Created by Sahil Satralkar on 03/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var stormImage: UIImageView!
    var selectedImage: String?
    var fileArrayCount = Int()
    var position = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            //UIImage will load the image onto the UIImageView IBOutlet
            stormImage.image  = UIImage(named: imageToLoad)
            // title is the keyword to assign title label text in the Navigation bar at top
            title = "Image \(position + 1) of \(fileArrayCount)"
        }
        
    }
    
    //Method will make the Navigation bar at top disappear from the top when user taps on the image
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        
    }
  
    //This method makes sure that the implemetation of hiding the navigation bar at top on user tap remains only on this View Controller.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
