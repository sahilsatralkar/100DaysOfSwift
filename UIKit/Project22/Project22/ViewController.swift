//
//  ViewController.swift
//  Project22
//
//  Created by Sahil Satralkar on 18/10/20.
//

import UIKit
import CoreLocation

//ViewController is also adheres to CLLocationManagerDelegate protocol.
class ViewController: UIViewController, CLLocationManagerDelegate {

    //Image view to show circle image for range
    @IBOutlet var circleView: UIView!
    //Label to display the text
    @IBOutlet var distanceReading: UILabel!
    //Label to display beacon number
    @IBOutlet var beaconNumber: UILabel!
    
    //Create CLLocationManager object
    var locationManager : CLLocationManager?
    
    //flag value to show beacon in range just once.
    var alertShownOnce =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        //circle view attributes at the time of loading
        circleView.layer.cornerRadius = 128
        circleView.backgroundColor = UIColor.gray
        
        //Request authorisatipn from iPhone user
        locationManager?.requestAlwaysAuthorization()
        
        //Default background color is gray
        view.backgroundColor = .gray

        //Beacon number text at the time of app loading
        beaconNumber.text = "No beacons"
    }
    
    //Internal function from CLLocationManagerDelegate. Called whenever use grants permission.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //For our use case we assume user will give always authorisation for location.
        if status == .authorizedAlways {
            //Check if our device has Monitoring facility
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                //Check if or device has ranging of beacons facillity.
                if CLLocationManager.isRangingAvailable() {
                    //Call scanning function. Calling it twice for 2 beacons
                    startScanning(uuid : "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")
                    startScanning(uuid : "74278BDA-B644-4520-8F0C-720EAF059935")
                }
            }
        }
    }
    
    //Called from didChangeAuthorization function.
    func startScanning(uuid : String) {
        
        //This UUID string is from Locate Beacon app which is to be downloaded on other testing device liske iPad.
        let uuid = UUID(uuidString: uuid)!
        
        //Create beacon with required attributes
        let beaconID = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconID, identifier: "MyBeacon")
        
        //locationManager methods for monitoring and ranging called
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconID)

    }
    
    //Internal function called from CLLocationManagerDelegate. Will be called whenever a beacon is in range.
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        
        
        //Fetch the first beacon from the array of beacons.
        if let beacon = beacons.first {
                        
            //This will show alert only once when beacon is in range
            if !alertShownOnce {
                let ac = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                alertShownOnce = true
                present(ac, animated: true)
            }
            
            //Switch case depending upon the beacon in range
            switch beacon.uuid.uuidString {
            
            case "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5" :
                update(distance: beacon.proximity, beaconNumber : "Beacon: 1")
            
            case "74278BDA-B644-4520-8F0C-720EAF059935" :
                update(distance: beacon.proximity, beaconNumber : "Beacon: 2")
                
            default :
                break
            
            }
        }
    }
    
    //Method is called by didRangeBeacons
    func update(distance: CLProximity, beaconNumber: String) {
        
        //Change screen state with animations
        UIView.animate(withDuration: 1) {
            
            //Assign white colour to circle
            self.circleView.backgroundColor = UIColor.white
            
            //Assign beacon number to beacon number label
            self.beaconNumber.text = beaconNumber
            
            //Switch cases for every CLProximity value and update values accordingly
            
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconNumber.text = "No Beacons"
                self.circleView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001 )
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.circleView?.transform = CGAffineTransform(scaleX: 0.25, y: 0.25 )

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.circleView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5 )

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.circleView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0 )
                
            default:
                break
            }
        }
    }
}

