//
//  Person.swift
//  Project10
//
//  Created by Sahil Satralkar on 10/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

//Custom class inherits the most basic NSObject class. Used to store collection properties
//Custom class also made to confirm to NSCoding protocol
class Person: NSObject, NSCoding {
    
    var name : String
    var image : String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    //Compulsory implementation for NSCoding protocol.
    //Used to encode class propeties
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image,forKey: "image")
    }
    
    //Compulsory implementation for NSCoding protocol.
    //Used to decode class properties
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }

}
