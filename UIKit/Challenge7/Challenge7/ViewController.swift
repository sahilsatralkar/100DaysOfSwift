//
//  ViewController.swift
//  Challenge7
//
//  Created by Sahil Satralkar on 17/10/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes.append("Mumbo jumbo")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row]
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the controller with unique identifier and typecasting it to be SecondViewController.
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            // 2: success! Set its selectedImage property
            
            //vc.textView.text = notes[indexPath.row]
            
            vc.textValue = notes[indexPath.row]
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
            //reloadData is called
            //self.tableView.reloadData()
            
            
        } else {
            print("View controller not found")
        }
        
        
    }


}

