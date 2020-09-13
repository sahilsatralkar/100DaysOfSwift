//
//  ViewController.swift
//  Project10
//
//  Created by Sahil Satralkar on 08/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

//Two delegate protocols are added. Class inheritance from UICollectionVIewController.
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Declaration of variables.
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Left bar button item for navigation bar created with selector function
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    //Function is called when user clicks on add button.
    @objc func addNewPerson() {
        //Image picker object is created
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        //This code will check for camera. Wont work in simulator.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        //assign the picker delegate theview controller and present picker.
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //Compulsory implementation for UICollectionViewController. return the number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    //Compulsory implementation fot UICollectionVIewController. Gets called for every item.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create cell from reusable cell id. downcast ir as Personcell.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        //Create cell object with its propertires and return
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    //Function is called when item is selected.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let person = people[indexPath.item]
        
        //Alert controller is created with 2 actions: For delete and rename the item label.
        let ac = UIAlertController(title: "Please choose", message: "Do you want to delete or rename image?", preferredStyle: .alert)
        
        //Action for Rename button. Another alert is called with textfield for new name.
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            self?.present(ac, animated: true)
            
        })
        //Action for delete button. will remove element from data array
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.people.remove(at: indexPath.row)
            
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    //OPtional method for Picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //UUID will create a unique file name id.
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        //Use jpegData to compress and write it to filepath
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        //Assign values to Person object.
        let person = Person(name: "unknown", image: imageName)
        people.append(person)
        
        //Reload data in view.
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    //Custom function to get file path url from filemanager.
    func getDocumentsDirectory () -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return path[0]
        return paths[0]
        
    }
}

