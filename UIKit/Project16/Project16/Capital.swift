//
//  Capital.swift
//  Project16
//
//  Created by Sahil Satralkar on 22/09/20.
//

import UIKit
import MapKit

//Capital class created which conforms to MKAnnotation protocol
class Capital: NSObject, MKAnnotation {
    
    var title : String?
    var coordinate : CLLocationCoordinate2D
    var info : String
    
    //initializer
    init(title : String, coordinate: CLLocationCoordinate2D, info : String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }

}
