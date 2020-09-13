//
//  ViewController.swift
//  Project12
//
//  Created by Sahil Satralkar on 13/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

//
//UserDefaults object creation. Add and fetch values from UserDefaults.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Userdefaults instance in created
        let defaults = UserDefaults.standard
        
        defaults.set(30 , forKey: "Age")
        defaults.set(true, forKey: "FaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.set("Sahil Satralkar", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let goodArray = ["Hello","World"]
        defaults.set(goodArray, forKey: "SavedArray")
        
        let dict = ["Name" : "Sahil", "Country": "India"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        
        let age = defaults.integer(forKey: "Age")
        let faceID = defaults.string(forKey: "FaceID")
        let name = defaults.string(forKey: "Name")
        
        let HWArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        let dictArray = defaults.object(forKey: "SavedDictionary") as? [String : String] ?? [String:String]()
        
        
        
        
    }


}

