//
//  ViewController.swift
//  Challenge4
//
//  Created by Sahil Satralkar on 14/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Variable declaration
    var imageDataArray = [ImageData]()
    var imageDataCount = 0
    //Create UserDefaults object
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title is the keyword to assign title label text in the Navigation bar at top
        title = "Picture viewer"
        // iOS recommended styling of Navigation bar title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Left bar button item for navigation bar created with selector function
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
        
        
        //Load people from ImageDataArray if it exists.
        if let tempImageDataArray = defaults.object(forKey: "ImageDataArray") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                //With JSONDecoder convert [ImageData] and assign to imageDataArray.
                imageDataArray = try jsonDecoder.decode([ImageData].self, from: tempImageDataArray)
                imageDataCount = imageDataArray.count
                
            } catch {
                print("Failed to load ImageDataArray")
            }
        }
        
        
    }
    
    //Selector function for Left navigation bar button
    @objc func addNewImage() {
        
        //Image picker object is created
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        //This code will check for camera. Wont work in simulator.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        //assign the picker delegate to the view controller and present picker.
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    //Function is auto called internally by UI PickerImageController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //fetch the image from info
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //UUID will create a unique file name id.
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        //Use jpegData to compress and write it to filepath
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        //Update counter
        imageDataCount += 1
        //Create a ImageData object with new custom property values and append to array.
        let imageData = ImageData(imageFileName: imageName, imageCellName: "Image \(imageDataCount)", viewCount: 0, caption: "")
        imageDataArray.append(imageData)
        
        //Save method called before reload
        save()
        //Reload data in view.
        tableView.reloadData()
        
        //Dismiss picker controller.
        dismiss(animated: true)
        
    }
    
    //Custom function to get file path url for documents from filemanager.
    func getDocumentsDirectory () -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return path[0]
        return paths[0]
        
    }
    
    //Save function will Encode imageDataArray with JSONEncoder before saving it to UserDefaults
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(imageDataArray) {
            defaults.set(savedData, forKey: "ImageDataArray")
        } else {
            print("Failed to save ImageDataArray")
        }
    }
    
    
    //Compulsary implementation for UITableViewController. Retuen the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageDataArray.count
    }
    
    //Compulsory implementation of UITableVieController. Assign datasource data to each reusable cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseID", for: indexPath) as? TableViewCell else {
            fatalError("Unable to dequeue TableViewCell.")
        }

        //Assign image and views counter to cell to display it.
        cell.imageLabel.text = imageDataArray[indexPath.row].imageCellName
        cell.imageViewCount.text = "Views : \(imageDataArray[indexPath.row].viewCount)"
        return cell
    }
    
    //This method will implement the logic for when a cell in the table view is tapped.
    //We will take the user to other View controller with the help of Navigation controller and then display the respective storm image.
    //Data which is required to display the appropriate image is also sent into the intance of the next View controller.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the controller with unique identifier and typecasting it to be SecondViewController.
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SecondScreen") as? SecondViewController {
            
            //Update views counter
            imageDataArray[indexPath.row].viewCount += 1
            //save data in UserDefaults with this function.
            save()
            vc.imageDataArraySVC = imageDataArray
            vc.indexRow = indexPath.row
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
            //reloadData is called
            self.tableView.reloadData()
            
            
        } else {
            print("View controller not found")
        }
        
    }
    
}

