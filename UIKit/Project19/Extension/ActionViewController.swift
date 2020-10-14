//
//  ActionViewController.swift
//  Extension
//
//  Created by Sahil Satralkar on 05/10/20.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    
    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem
        {
            
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String ) {
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        
                        
                    }
                    
                }
            }
        }
    
    }
    
    @objc func compose() {
        
        let ac =  UIAlertController(title: "JavaScript options", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Examples", style: .default){_ in
            
            let eac = UIAlertController(title: "Examples", message: nil, preferredStyle: .alert)
            eac.addAction(UIAlertAction(title: "Number Square", style: .default, handler:{_ in
            
                self.script.text = "var x = 2 \n\nalert(x*x)"
            
            }))
            
            eac.addAction(UIAlertAction(title: "Number Square root", style: .default, handler:{_ in
            
                self.script.text = "var x = 16\n\nalert(Math.sqrt(x))"
            
            }))
            
            eac.addAction(UIAlertAction(title: "Number Addition", style: .default, handler:{_ in
            
                self.script.text = "var x = 16\n\nvar y = 5\n\nalert(x+y)"
            
            }))
            
            eac.addAction(UIAlertAction(title: "Number Substraction", style: .default, handler:{_ in
            
                self.script.text = "var x = 16\n\nvar y = 5\n\nalert(x-y)"
            
            }))
            self.present(eac, animated: true)
            
            
        })
        ac.addAction(UIAlertAction(title: "Save", style: .default))
        ac.addAction(UIAlertAction(title: "Load", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
        
    }
    
    func exampleHandler (action: UIAlertAction){
        //script.text = "Yellow submarine"
    }

    @IBAction func done() {
        
        let item = NSExtensionItem()
        let argument : NSDictionary = ["customJavaScript" : script.text]
        let webDictionary : NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey : argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
    }
    
    @objc func adjustForKeyboard(notification : Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
            
        }else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom , right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
