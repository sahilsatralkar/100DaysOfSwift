//
//  DetailViewController.swift
//  Challenge9
//
//  Created by Sahil Satralkar on 30/10/20.
//

import UIKit

class DetailViewController: UIViewController {

    //IBOutlet for the image
    @IBOutlet var detailImage: UIImageView!
    
    var tempImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set nav bar right button as method call to shareImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))

        detailImage.image = tempImage
        
    }
    
    //Selector function which will show UIActivityViewController to share image
    @objc func shareImage() {
        guard let image = detailImage.image?.jpegData(compressionQuality: 0.8) else {
                print("No image found")
                return
            }

            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
    }

}
