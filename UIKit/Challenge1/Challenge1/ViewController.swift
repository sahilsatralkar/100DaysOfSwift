//
//  ViewController.swift
//  Challenge1
//
//  Created by Sahil Satralkar on 12/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //array to store the names of flag.
    var flagNameArray = [String]()
    
    //Code to remove the "@2x" suffix to file name within array.
    var updateImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default implementation for Filemanager to handle files in Swift
        let fm = FileManager.default
        //default path for files in project. Can be safely unwrapped.
        let path = Bundle.main.resourcePath!
        //This will create an array of NSString with the names of files
        let items = try! fm.contentsOfDirectory(atPath: path)
        //Create a flagNameArray which will filter files containing 2x in name.
        for item in items {
            if item.contains("2x") {
                flagNameArray.append(item)
            }
        }
        //default implmentation for Navigation bar text.
        title = "Challenge 1"
        //Apple recommended styling for Navigation bar.
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //Mandatory implementation of this method override.
    //Need to return the number of rows in teh UITableView.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagNameArray.count
    }
    
    //Mandatory implementation of this method override.
    //This method is called internally for every time for a row in Table View.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creating a new reusable cell with Identifier for cell as given in main.storyboat attributes inspector.
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
        let imageInACell = UIImage(named: flagNameArray[indexPath.row])
        
        //Code to remove the "@2x" suffix to file name within array.
        var updateImageName = ""
        for c in flagNameArray[indexPath.row] {
            if c == "@" {
                break
            } else {
                updateImageName.append(c)
            }
        }
        
        //make all strings within the array to uppercase.
        updateImageName = updateImageName.uppercased()
        //set image
        cell.imageView?.image = imageInACell
        //set text
        cell.textLabel?.text = updateImageName
        return cell
    }
    
    //This method will detect the tap on the cell by user and redirect to next screen.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Create an instance of DetailViewController from the storyboard.
        if let dvc = storyboard?.instantiateViewController(identifier: "SecondScreen") as? DetailViewController {
            //set image in DetailViewController as per selected row.
            dvc.selectedImage = flagNameArray[indexPath.row]
            //push the DetailViewController instance into the navigationController instance.
            navigationController?.pushViewController(dvc, animated: true)
        }
        //Condition if no DetailViewController in main.storyboard.
        else {
            print("Detail view controller not available")
        }
    }
}

