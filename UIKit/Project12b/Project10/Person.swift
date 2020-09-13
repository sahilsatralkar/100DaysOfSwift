//
//  Person.swift
//  Project10
//
//  Created by Sahil Satralkar on 10/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

//Custom class inherits the most basic NSObject class. Used to store collection properties
class Person: NSObject {
    
    var name : String
    var image : String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
