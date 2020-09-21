//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Sahil Satralkar on 21/09/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var detailCountry = Country(countryName: "", population: 0, area: 0, capitalCity: "", currency: "", summary: "")
    
    @IBOutlet var country: UILabel!
    @IBOutlet var population: UILabel!
    @IBOutlet var area: UILabel!
    @IBOutlet var capital: UILabel!
    @IBOutlet var currency: UILabel!
    @IBOutlet var summary: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        country.text = "Country: \(detailCountry.countryName)"
        population.text = "Population: \(String(detailCountry.population))"
        area.text = "Area: \(String(detailCountry.area)) sq km"
        capital.text = "Capital: \(detailCountry.capitalCity)"
        currency.text = "Currency: \(detailCountry.currency)"
        summary.text = "Summary: \(detailCountry.summary)"
        
        //To disable the large Navigation bar text label
        navigationItem.largeTitleDisplayMode = .never
      
    }
    
    
   
}
