//
//  ViewController.swift
//  Project 1
//
//  Created by Sahil Satralkar on 01/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var fileNameArray = [String]()
    var position = Int()
    var rowCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title is the keyword to assign title label text in the Navigation bar at top
        title = "Storm viewer"
        
        // Default implementation to access file system in Swift code
        let fm = FileManager.default
        // Default implementation to fetch the file path of Project directory. Can safely force unwrap the optional here
        let path = Bundle.main.resourcePath!
        //Default implemention to get an array of NSString which will contain file name of assets.
        //Can also be force unwrapped with try! to avoid throws as it wont.
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        //Will create 2 other arrays from items array.
        for item in items {
            if item.hasPrefix("nssl") {
                fileNameArray.append(item)
                rowCount += 1
            }
        }
        
        fileNameArray.sort()
        
        // iOS recommended styling of Navigation bar title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //This method implementation is compulsury when UITableViewController is implementated class.
    //Method will take the count of rows to be diplayed in table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNameArray.count
    }
    
    //This method implementation is compulsury when UITableViewController is implementated class.
    //Method will have reusable cell with uniques identifier. This method is called for every row of table to be created.ßß
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileNameRow", for: indexPath)
        cell.textLabel?.text = "Image \(indexPath.row + 1)"
        return cell
    }
    
    //This method will implement the logic for when a cell in the table view is tapped.
    //We will take the user to other View controller with the help of Navigation controller and then display the respective storm image.
    //Data which is required to display the appropriate image is also sent into the intance of the next View controller.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the controller with unique identifier and typecasting it to be SecondViewController.
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SecondScreen") as? SecondViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = fileNameArray[indexPath.row]
            vc.fileArrayCount = fileNameArray.count
            vc.position = indexPath.row
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("View controller not found")
        }
        
    }
    
    
}

