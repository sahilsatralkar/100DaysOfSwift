//
//  ViewController.swift
//  Project15
//
//  Created by Sahil Satralkar on 20/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    //Declaration of variables
    var imageView : UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the penguin image from Assets
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        //Add image to ViewController
        view.addSubview(imageView)
        
    }

    @IBAction func tapped(_ sender: UIButton) {
        //Hide button when user taps
        sender.isHidden = true
        
        //UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        
        //animate with spring animations the image
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {

        // Using switch to give 7 different animations
        switch self.currentAnimation {
            case 0 :
                //Scale image 2 times
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            case 1 :
                //restore image original state
                self.imageView.transform = .identity
               
            case 2 :
                //Move the image to given coordinates
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                //restore image original state
                self.imageView.transform = .identity

            case 4 :
                //Rotate image by 180 deg.
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                
            case 5 :
                //restore image original state
                self.imageView.transform = .identity
                
            case 6 :
                //Make image almost transparent and background green
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            
            case 7:
                //make image opaque and clear background
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
                
            default :
                break
            
            }
        }) { (finished) in
            //Unhide button after finishing animation
            sender.isHidden = false
        }
        //increment counter
        currentAnimation += 1
        
        //reset counter.
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

