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
    var fileNameArrayLabel = [String]()
    var position = Int()
    var photosCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title keyword is for the navigation bar title label text.
        title = "Storm viewer"
        
        //Default implementation to fetch the FileManager object for photo files handling
        let fm = FileManager.default
        //Default path for the project directory. Can be safely force unwrapped.
        let path = Bundle.main.resourcePath!
        //Will return the NSString array containg file names.
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            //Our library of photos have prefix of nssl.
            if item.hasPrefix("nssl") {
                fileNameArray.append(item)
                //variable to count the number of photos.
                photosCount += 1
                //This array will contain fabricated string to display on table cell
                fileNameArrayLabel.append("Image \(photosCount)")
            }
        }
        
        //sort method on NSString array will sort the names of files alphabetically.
        fileNameArray.sort()
        //Apple recommended styling of Navigation bar text.
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    //This method is compulsory implementation for UITableViewController
    //Inside this method we need to return the number of rows in the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNameArray.count
    }
    
    //This method is compulsory implementation for UITableViewController
    //We create a reusable cell and link it to datasource. Method is called for every cell in table.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cell identifier is as given in Identifier in Attributes inspector for cell in main.storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileNameRow", for: indexPath)
        cell.textLabel?.text = fileNameArrayLabel[indexPath.row]
        return cell
    }
    
    //This method is called each time user taps on a cell in table.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //This will create an instance of SecondViewController from the storyboard
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SecondScreen") as? SecondViewController {
            // Set the values inside the properties with instance of SecondViewController i.e. vc
            vc.selectedImage = fileNameArray[indexPath.row]
            vc.fileNameArrayLabelSVC = fileNameArrayLabel
            vc.position = indexPath.row
            //this will push the SecondViewController onto the navigationController object
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}

