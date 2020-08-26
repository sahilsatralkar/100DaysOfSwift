//
//  ViewController.swift
//  Challenge2
//
//  Created by Sahil Satralkar on 26/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //var to store the list of shoppping items.
    var shoppingListArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the two button on the navigation bar. Selector has the reference to appropriate objective c function.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItemList))
        
        //Will set the title for navigation bar.
        title = "Shopping List app"
        
    }
    
    //This function will reset the shopping list array and reload table view.
    @objc func deleteItemList () {
        shoppingListArray = []
        tableView.reloadData()
    }
    
    //This function will add items to the shopping list array and reload table view
    @objc func addItem() {
        
        let ac = UIAlertController(title: "Shopping List", message: "Please enter new shopping item", preferredStyle: .alert)
        ac.addTextField ()
        //UIAlertAction will user a closure which will pass weak self and weak UIAlertController object as its values will be set inside it.
        let action = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] action in
            guard let userTextInput = ac?.textFields?[0].text else {
                return
            }
            //Insert method will insert new items at start of the List and will push other items down.
            self?.shoppingListArray.insert(userTextInput, at: 0)
            self?.tableView.reloadData()
            
        }
        
        //Add the action to UIAlertController object.
        ac.addAction(action)
        //Alert is presented.
        present(ac, animated: true)
        
    }
    
    //Compulsory implementation for UITableViewController. Will return the number of rows in shoppingListArray.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shoppingListArray.count
    }
    
    //Compulsory implementation for UITableViewController.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create a new reusable cell of Identifier as in main.storyboard, identifier in attributes inspector for cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = shoppingListArray[indexPath.row]
        return cell
    }
}
