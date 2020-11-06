//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
	var dirty = false
    
    //Array to store all images
    var imagesArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none

		// load all the JPEGs into our array
		let fm = FileManager.default

        //do try catch block to avoid force unwrap on try for Challenge
        if let resourcePath = Bundle.main.resourcePath  {
            
            do {
                let tempItems = try fm.contentsOfDirectory(atPath: resourcePath)
                for _ in 0 ..< 10 {
                    for item in tempItems {
                        if item.range(of: "Thumb.jpg") != nil {
                            items.append(item)
                            if let image = UIImage(named: item) {
                                imagesArray.append(image)
                            }
                            
                        }
                    }
                }
                
            } catch {
                print("Error in accessing file manager.")
            }
        }
        
	}
    
    //Function to get documents directory of image files
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return imagesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Dequereusable cell used to resuse cell
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
		
        let original = imagesArray[indexPath.row]
        
        

        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)

        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()

            original.draw(in: renderRect)
        }

		cell.imageView?.image = rounded

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: items[indexPath.row]))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
		viewControllers.append(vc)
		navigationController!.pushViewController(vc, animated: true)
	}
}
