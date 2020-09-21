//
//  ViewController.swift
//  Challenge5
//
//  Created by Sahil Satralkar on 21/09/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country wiki"
        // iOS recommended styling of Navigation bar title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let fileURL = Bundle.main.url(forResource: "countries", withExtension: "json") {
            if let data = try? Data(contentsOf: fileURL) {
                parse(json: data)
            }
        }
        
    }
    
    //Function will parse the Data received from URL
    func parse(json : Data) {
        //decoder object created
        let decoder = JSONDecoder()
        //with the decode method we can fetch the results inside Petitions structure directly because they also confirm to Codable protocol.
        if let jsonCountries =  try? decoder.decode(Countries.self, from: json) {
            //Assign the results to petitions array.
            countries = jsonCountries.results
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = countries[indexPath.row].countryName
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Create an instance of DetailViewController from the storyboard.
        if let dvc = storyboard?.instantiateViewController(identifier: "SecondScreen") as? DetailViewController {
            dvc.detailCountry = countries[indexPath.row]
            //push the DetailViewController instance into the navigationController instance.
            navigationController?.pushViewController(dvc, animated: true)
        }
        //Condition if no DetailViewController in main.storyboard.
        else {
            print("Detail view controller not available")
        }
        
    }
    
    


}

