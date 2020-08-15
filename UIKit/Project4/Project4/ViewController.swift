//
//  ViewController.swift
//  Project4
//
//  Created by Sahil Satralkar on 15/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit
import WebKit

//ViewController also comfirms to WKNavigationDelegate protocol
class ViewController: UIViewController, WKNavigationDelegate {

    //Create a new instance of WKWebView type
    var webView : WKWebView!
    
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
        //Create Navigation bar button and assign it #selector action.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        
        //Create a default URL object.
        let url = URL(string: "https://www.hackingwithswift.com")!
        //Load the url on webView
        webView.load(URLRequest(url: url))
        //This code will enable user to swipe back and forwar the web pages.
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //@objc annotation necessary as #selector is objective C code
    @objc func selectButtonTapped(){
        
        //Create new UIAlertController object with preferredStyle as .actionSheet becaouse it will contain multiple urls/\
        let ac = UIAlertController(title: "open page...", message: nil, preferredStyle: .actionSheet)
        //Adding the multiple url's. handler function openPage is defined outside.
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction((UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage)))
        //For the cancel option the handler is removed which means none handler.
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        //COde necessary for iPad
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        //present the UIAlertController instance.
        present(ac, animated: true)
        
    }
    
    func openPage(action: UIAlertAction) {
        //Prepare the string for URL.
        let url = URL(string: "https://www." + action.title!)!
        //load the url on webView.
        webView.load(URLRequest(url: url))
    }
    
    //Inbuilt function for webView. This will just set the title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

}

