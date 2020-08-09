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
    var fileNameArrayLabelSVC = [String]()
    var position = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            stormImage.image  = UIImage(named: imageToLoad)
            title = "Image \(position + 1) of \(fileNameArrayLabelSVC.count)"
        }
        navigationItem.largeTitleDisplayMode = .never
    }

}
