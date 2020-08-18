//
//  FirstViewController.swift
//  Project4
//
//  Created by Sahil Satralkar on 18/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var websites = ["google.com", "hackingwithswift.com","wikipedia.org"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Website list"
        
        //Apple recommended styling of Navigation bar text.
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteCell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "websiteView") as? SecondViewController {
            
            vc.websites = self.websites
            vc.websiteSelectRow = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
