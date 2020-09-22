//
//  SecondViewController.swift
//  Project16
//
//  Created by Sahil Satralkar on 22/09/20.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, WKNavigationDelegate {
    
    //Create a new instance of WKWebView type
    var webView : WKWebView!
    var selectedCity = "Paris"
    
    override func loadView() {
        //Initialise webView
        webView = WKWebView()
        //Make the webView.navigationDelegate to ViewController
        webView.navigationDelegate = self
        //assign the weVIew to the root view
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a default URL for wikipedia and string interpolation for city name
        let url = URL(string: "https://en.wikipedia.org/wiki/\(selectedCity)")!
        //Load the url on webView
        webView.load(URLRequest(url: url))
        //This code will enable user to swipe back and forwar the web pages.
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
}
