//
//  ViewController.swift
//  Project16
//
//  Created by Sahil Satralkar on 22/09/20.
//

import UIKit
import MapKit

//ViewController conforms to MKMapViewDelegate
class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Create Capital objects for different cities
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        
        //Add to mapView IBOutlet the Capital objects
        mapView.addAnnotations([london, oslo, paris, rome])
        
        //Navigation bar title
        title = "Map view"
        
    }
    
    //Internal function for MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1 Check annotation confirms to Capital class annotation
        guard annotation is Capital else { return nil }
        
        // 2 Create a constant
        let identifier = "Capital"
        
        // 3 from mapView method dequeueReusableAnnotationView fetch view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            //Create a button without action
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            
            annotationView?.annotation = annotation
        }
        //Challenge 1 to change pinTintColor to blue
        annotationView?.pinTintColor = .blue
        
        return annotationView
    }
    
    // Internal function for MKMapViewDelegate called if accessory is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let capital = view.annotation as? Capital else { return }
        //fetch details in constants
        let placeName = capital.title
        let placeInfo = capital.info
        
        //Create an alert with the message
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        //Add action button for displaying map in Satellite view
        ac.addAction(UIAlertAction(title: "Satellite map", style: .default, handler: { (alert) in
            
            //method to change map to Satellite
            self.mapView.mapType = .satellite
            
        }))
        
        //Add action button for displaying map in Hybrid view
        ac.addAction(UIAlertAction(title: "Hybrid map", style: .default, handler: { (alert) in
            
            //method to change map to hybrid
            self.mapView.mapType = .hybrid
            
        }))
        
        //Add action to take user to Wikepedia page for selected city
        ac.addAction(UIAlertAction(title: "Wiki page", style: .default, handler: { (alert) in
            
            //INstantiate SecondViewController from storyboard
            if let vc = self.storyboard?.instantiateViewController(identifier: "websiteView") as? SecondViewController {
                //Pass the value of City name for Wiki url
                vc.selectedCity = placeName!
                //Push the SecondViewCOntroller to navigationController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }))
        
        //Present the alert to user
        present(ac, animated: true)
    }
}

