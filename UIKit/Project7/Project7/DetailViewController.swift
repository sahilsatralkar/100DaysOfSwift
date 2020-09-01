//
//  DetailViewController.swift
//  Project7
//
//  Created by Sahil Satralkar on 01/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    //Create WKWebView object
    var webView : WKWebView!
    //Variable to get the data from ViewController
    var detailItem : Petition?
    
    //Necessaray method to load webview.
    override func loadView() {
        
        webView = WKWebView()
        //Assign webView to Controller view.
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        //Create a multi line string in html format
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body {font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
        //code to load the html string into webView.
        webView.loadHTMLString(html, baseURL: nil)
        
    }
}
