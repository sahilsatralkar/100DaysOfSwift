//
//  Petitions.swift
//  Project7
//
//  Created by Sahil Satralkar on 31/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import Foundation

//
// Struct declared which confirms to Codable protocol. The property name matches the array from the JSon it will receive.
struct Petitions : Codable {
    
    var results: [Petition]
    
}
