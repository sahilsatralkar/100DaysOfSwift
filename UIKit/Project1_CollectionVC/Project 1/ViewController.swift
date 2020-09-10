//
//  ViewController.swift
//  Project 1
//
//  Created by Sahil Satralkar on 01/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate {
    
    //Variable declaration
    var fileNameArray = [String]()
    var position = Int()
    var rowCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title is the keyword to assign title label text in the Navigation bar at top
        title = "Storm viewer"
        
        //Fetching images task is sent to background thread.
        performSelector(inBackground: #selector(fetchImages), with: nil)
       
        //Sent collection reload data to main thread
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
     
    }
    
    //Function to fetch images
    @objc func fetchImages() {
        
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
        
    }
    
    //This method implementation is compulsury when UICollectionViewController is implementated class.
    //Method will take the count of items to be diplayed in collection view.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileNameArray.count
    }
    
    //This method implementation is compulsury when UITableViewController is implementated class.
    //Method will have reusable cell with uniques identifier. This method is called for every row of table to be created.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? LabelCell  else {
            fatalError("Unable to dequeue LabelCell")
        }
        
        cell.imageName.text = "Image \(indexPath.row + 1)"
        cell.imageView.image = UIImage(named: fileNameArray[indexPath.row])
        return cell
        
    }
    
    //Function will be called when user clicks of cell.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         //1: try loading the controller with unique identifier and typecasting it to be SecondViewController.
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

