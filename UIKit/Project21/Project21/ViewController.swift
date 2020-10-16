//
//  ViewController.swift
//  Project21
//
//  Created by Sahil Satralkar on 16/10/20.
//

import UIKit
import UserNotifications

//View controller confirms to UNUserNotificationCenterDelegate
class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //Flag to set the values for notification timer
    var remindMeLaterFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create 2 navigation bar buttons to Register and Schedule
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }

    //Selector function for Register button
    @objc func registerLocal() {
        
        //Create notification center object
        let center = UNUserNotificationCenter.current()
        //Assign it all available options
        center.requestAuthorization(options: [.alert,.badge,.sound]) {
            //closure has 2 parameters granted and error
            granted, error in
            if granted {
                print("YAY!")
                
            }
            else {
                print("D'oh!")
            }
        }
        
    }
    
    //Selector function for Schedule button
    @objc func scheduleLocal() {
        
        //Call internal function
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        var timeInterval = 5.0
        if remindMeLaterFlag == true {
            timeInterval = 86400
        }
        
        print("time interval : \(timeInterval)")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    //Method is called from Register functions
    func registerCategories(){
        
        //Create new Noification center object and assign its delegate to ViewController
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        //Create 2 notification actions for Show and Reminder.
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later...", options: .foreground)
        
        //Create User Notification category and assign the 2 actions
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])
        
        //Assign the category to notification center
        center.setNotificationCategories([category])
        
        
    }
    
    //Method we can get from UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //fetch userinfo from response
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            
            print("Custom data received:\( customData)")
            
            //Switch cases for different actions
            switch response.actionIdentifier {
            
            case UNNotificationDefaultActionIdentifier :
                //
                print("Default identifier")
                
            case "show":
                print("Show more information...")
                
                let ac = UIAlertController(title: "Information", message: "Additional information here", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac,animated: true)
                
            case "reminder":
                print("Within reminder switch case...")
                remindMeLaterFlag = true
                scheduleLocal()
                remindMeLaterFlag = false
                
            default:
                break
            }
            
        }
        //Call completion handle as its @escaping in method parameter
        completionHandler()
        
    }

}

