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
class SecondViewController: UIViewController, WKNavigationDelegate {

    //Create a new instance of WKWebView type
    var webView : WKWebView!
    
    //Create a UIProgressView object
    var progressView : UIProgressView!
    
    var websites = [String]()
    var websiteSelectRow = 0
    
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
        
        //this code is necessay to get the small font styling for navigation bar title text.
        navigationItem.largeTitleDisplayMode = .never
        
        //Create Navigation bar button and assign it #selector action.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        
        //Create 4 different button.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        //Add buttons to toolbarItems
        toolbarItems = [progressButton, spacer, refresh, goBack, goForward]
        //Unhide the toolbar from navigationController.
        navigationController?.isToolbarHidden = false
        
        //Create a default URL object.
        let url = URL(string: "https://www." + websites[websiteSelectRow])!
        //Load the url on webView
        webView.load(URLRequest(url: url))
        //This code will enable user to swipe back and forwar the web pages.
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //@objc annotation necessary as #selector is objective C code
    @objc func selectButtonTapped(){
        
        //Create new UIAlertController object with preferredStyle as .actionSheet becaouse it will contain multiple urls/\
        let ac = UIAlertController(title: "open page...", message: nil, preferredStyle: .actionSheet)
        
        //add multiple action for each website.
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        //For the cancel option the handler is removed which means none handler.
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        //Code necessary for iPad
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
    
    //This method is useful to fetch the observer value i.e. website load progress.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    //decidePolicyFor will restrict navigation to only the websites listed.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        //Alert is displayed to user if they try to navigate to website other than listed.
        let ac = UIAlertController(title: "Navigation stopped", message: "Link is not safe", preferredStyle: .alert)
        //New UIAlertAction created. handler label is passed the askQuestion function as parameter.
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        //Present the alert
        self.present(ac, animated: true)
        decisionHandler(.cancel)
    }
    
}

