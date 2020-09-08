//
//  ViewController.swift
//  Project7
//
//  Created by Sahil Satralkar on 31/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    //Arrays are declared to store the petitions.
    var petitions = [Petition]()
    var tempPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Right and left navigation bar items are declared and selector functions are called.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(dataAlert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchResults))
        
        let urlString: String
        
        //Both the tab bar controllers will call different urls.
        if navigationController?.tabBarItem.tag == 0 {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            
        } else {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            
        }
        
        //Create URL object
        if let url = URL(string: urlString) {
            //fetch the contents of url in Data format
            if let data = try? Data(contentsOf: url) {
                //parse  function is called and data is passed as parameter.
                parse(json: data)
            }
        }
        //Perform tableview.reloadData on main thread.
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    //Selector function for right navigation bar button. This will display a simple alert to show the source of the API.
    @objc func dataAlert() {
        
        let ac = UIAlertController(title: "Information Source", message: "We The People API", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
        
    }
    
    //Selector function for  left navigation bar button.
    //This will filter the petition according to the text input by user.
    @objc func searchResults() {
        
        let ac = UIAlertController(title: "Search Text", message: "Enter text to filter results", preferredStyle: .alert)
        ac.addTextField()
        let searchAction = UIAlertAction(title: "Go", style: .default) {
            [weak self, weak ac] action in
            guard let searchText = ac?.textFields?[0].text else { return }
            self!.searchInPetitions(searchText)
            
        }
        
        ac.addAction(searchAction)
        present(ac,animated: true)
    }
    
    //Function to search and filter the Petitions.
    func searchInPetitions(_ searchText : String) {
        //Search tasks are send to background thread
        performSelector(inBackground: #selector(searchInPetitionsBackground), with: searchText)
        
    }
    
    //Function to filter petitions in background.
    @objc func searchInPetitionsBackground(_ searchText : String) {
        
        tempPetitions.removeAll()
        for petition in petitions {
            //Check the entered text by user within the body of petition. Checks done on lowercased strings.
            if petition.body.lowercased().contains(searchText.lowercased()) {
                tempPetitions.append(petition)
            }
        }
        
        //Reassign the new petitions to original petitions array and the reload table data so that same functions will be reused as is.
        petitions.removeAll()
        petitions = tempPetitions
        
        //tableview.reloadData in Main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Function will parse the Data received from URL
    func parse(json : Data) {
        //decoder object created
        let decoder = JSONDecoder()
        //with the decode method we can fetch the results inside Petitions structure directly because they also confirm to Codable protocol.
        if let jsonPetitions =  try? decoder.decode(Petitions.self, from: json) {
            //Assign the results to petitions array.
            petitions = jsonPetitions.results
        }
        
    }
    
    //Mandatory implementation of UITableViewController class. Need to return the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    //Mandatory implementation of UITableViewController. Populate the reusable cell and return it. Method called internally for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        
        return cell
    }
    
    //Method iscalled when user taps a cell in table.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Creating instance of DetailViewController
        let vc = DetailViewController()
        //Populated data
        vc.detailItem = petitions[indexPath.row]
        //Push vc in navigationController.
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

