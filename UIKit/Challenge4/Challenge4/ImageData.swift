//
//  ImageData.swift
//  Challenge4
//
//  Created by Sahil Satralkar on 15/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ImageData: NSObject, Codable {
    
    var imageFileName : String
    var imageCellName : String
    var viewCount : Int
    var caption : String
    
    init(imageFileName : String, imageCellName: String, viewCount : Int, caption : String){
        self.imageFileName = imageFileName
        self.imageCellName = imageCellName
        self.viewCount = viewCount
        self.caption = caption
    }

}
