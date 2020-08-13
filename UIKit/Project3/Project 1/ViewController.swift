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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm viewer"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        print(items)
        var count = 0
        for item in items {
            if item.hasPrefix("nssl") {
                print("Item : \(item)")
                fileNameArray.append(item)
                count += 1
                fileNameArrayLabel.append("Image \(count)")
            }
        }
        fileNameArray.sort()
        print("fileNameArray: \(fileNameArray)")
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileNameRow", for: indexPath)
        cell.textLabel?.text = fileNameArrayLabel[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SecondScreen") as? SecondViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = fileNameArray[indexPath.row]
            vc.fileNameArrayLabelSVC = fileNameArrayLabel
            vc.position = indexPath.row
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}

