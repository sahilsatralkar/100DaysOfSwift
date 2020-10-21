//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Sahil Satralkar on 18/10/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    var textValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = textValue
        

    }
    

}
