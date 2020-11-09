//
//  ViewController.swift
//  Challenge10
//
//  Created by Sahil Satralkar on 08/11/20.
//

import UIKit

class ViewController: UICollectionViewController {
    
    //Variables declaration
    var cardImages = [UIImage]()
    var cardImageNames = [String]()
    
    //Dictionary of correct answers
    var answerBook = [String : String ]()
    
    //Count the number of pairs guessed
    var answerCounter = 0
    
    //Set numbers for index logic
    var firstCardIndexGlobal = -10
    var secondCardIndexGlobal = -10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the names of cards
        cardImageNames = ["paris","france","italy","rome","india","delhi"]
        //Set the correct answers of pairs
        answerBook = ["italy" : "rome", "india" : "delhi", "france": "paris","rome":"italy","delhi":"india","paris":"france"]
        //Shuffle the names array before each game
        cardImageNames.shuffle()
        
    }

    //Called internally to set the number of items in collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardImageNames.count
    }
    
    //Called internally to set data for each cell in collection
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        //Create a new reusable cell with identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //Get the UIImageView within the cell with the tag number in main.storyboard
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            //Set default image
            imageView.image = UIImage(named: "cross")
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.darkGray.cgColor
            
        }
        
        return cell
    }
    
    //Called internally when a cell is tapped.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let imageView = cell?.viewWithTag(100) as? UIImageView {
            imageView.image = UIImage(named: cardImageNames[indexPath.row])
            // set spin animation while changing card image
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: [], animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                imageView.transform = CGAffineTransform.identity
            })
            //Logic to check the pairs
            if firstCardIndexGlobal < 0 {
                firstCardIndexGlobal = indexPath.row
            } else if firstCardIndexGlobal != indexPath.row {
                secondCardIndexGlobal = indexPath.row
                //Function called to check the answers
                checkAnswers(firstCardIndex: firstCardIndexGlobal, SecondCardIndex: secondCardIndexGlobal, indexPath: indexPath)
                
            }
        }
    }
    
    //FUnction which contains logic for the logic
    func checkAnswers (firstCardIndex : Int, SecondCardIndex : Int,  indexPath: IndexPath) {
        
        //Create constants
        let firstCard = cardImageNames[firstCardIndex]
        let secondCard = cardImageNames[secondCardIndexGlobal]
        let cardImageCheck = answerBook[firstCard]
        
        //If correct pairs guessed
        if cardImageCheck == secondCard {
            
            answerCounter += 1
            
            if answerCounter == 3 {
                
                //Present the you win screen
                guard let vc = storyboard?.instantiateViewController(identifier: "youwin") else { return}
                present(vc, animated: true)
                
            }
        }
        //If wrong pairs guessed
        else {
            
            //Logic to reset the pair of cards
            let cell1 = collectionView.cellForItem(at: [0,firstCardIndex])
            let cell2 = collectionView.cellForItem(at: [0,SecondCardIndex])
            
            if let imageView = cell1?.viewWithTag(100) as? UIImageView {
                
                imageView.image = UIImage(named: "cross")
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: [], animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    imageView.transform = CGAffineTransform.identity
                })
                
            }
            
            if let imageView = cell2?.viewWithTag(100) as? UIImageView {
                imageView.image = UIImage(named: "cross")
                
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: [], animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    imageView.transform = CGAffineTransform.identity
                })
                
            }
            
        }
        
        //Reset the indexes
        self.firstCardIndexGlobal = -10
        self.secondCardIndexGlobal = -10
        
    }
}

