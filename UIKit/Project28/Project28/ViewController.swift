//
//  ViewController.swift
//  Project28
//
//  Created by Sahil Satralkar on 31/10/20.
//

import UIKit
//Required import for Biometric authentication
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    var password = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        //Create notificationCenter object and add observers for Keyboard and Resign active notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        KeychainWrapper.standard.set("abcd1234", forKey: "SecretPassword")
        //Fetch password from keychain wrapper
        password = KeychainWrapper.standard.string(forKey: "SecretPassword") ?? "abcd1234"
    }
    
    //IBAction for Authenticate button tapped
    @IBAction func authenticateTapped(_ sender: Any) {
        //Create context for Local authentication and create NSError object
        let context = LAContext()
        var error: NSError?
        
        //Ask for Biometric authentication permission for the app
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                //Run the Authentication on the main thread only.
                DispatchQueue.main.async {
                    if success {
                        //Call to unlock the message function. Default value hidden
                        self?.unlockSecretMessage()
                        
                    } else {
                        //                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        //                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        //                        self?.present(ac, animated: true)
                        
                        
                        //New UIAlertController object for entering password if biometric authentification fails
                        let ac = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
                        //Uset input textfield added.
                        ac.addTextField()
                        //UIAlertAction object is created.
                        let submitAction = UIAlertAction(title: "OK", style: .default) {
                            [weak self, weak ac] action in
                            
                            if self?.password == ac?.textFields?[0].text {
                                self?.unlockSecretMessage()
                            //Condition if password entered is wrong.
                            } else {
                                
                                let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self?.present(ac, animated: true)
                                
                            }
                            
                        }
                        //Action is added to UIAlertController.
                        ac.addAction(submitAction)
                        //Present Alert.
                        self?.present(ac, animated: true)
                    }
                }
            }
            
        //Condition of Biometry is not configured
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    //Code to adjust the keyboard so that the text wont go behind the keyboard.
    @objc func adjustForKeyboard(notification : Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
        
    }
    
    //Function to unhide the message
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        //Create a bar button only within Message screen for saving it.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSecretMessage))
        
        //Fetch the text from Keychain.
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    //Function to save the message.
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        //Save the text in Keychain
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        //Hide the bar button to save
        navigationItem.rightBarButtonItem = nil
        title = "Nothing to see here"
    }
}

