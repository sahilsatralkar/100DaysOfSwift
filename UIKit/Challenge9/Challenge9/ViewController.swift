//
//  ViewController.swift
//  Challenge9
//
//  Created by Sahil Satralkar on 30/10/20.
//

import UIKit

//Class confirms to UIImagePickerControllerDelegate & UINavigationControllerDelegate
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Array of images
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title of view controller
        title = " iMeme"
        
        //Set right button on nav bar as method call to selectImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectImage))
    }

    //Selector method for right bar button
    @objc func selectImage (){
        
        //New picker object
        let picker = UIImagePickerController()
        //Allows editing
        picker.allowsEditing = true
        //set delegate as ViewController
        picker.delegate = self
        //Present picker controller
        present(picker,animated: true)
        
    }
    
    //Complulsory implementation for UICollectionViewController. Return number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    //Compulsory implementation for UICollectionViewController. Prepare reusable cell and set values and return
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        //image view is identified by tag number in storyboard
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
        
    }
    
    //Function to create alert for meme text at the top
    func memeTextTop() {
        let ac1 = UIAlertController(title: "Text at the top", message: nil, preferredStyle: .alert)
        ac1.addTextField()

        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned ac1] _ in
            let answer = ac1.textFields![0]
            //Call function for meme text at bottom
            self.memeTextBottom(topText: answer.text)
            
        }

        ac1.addAction(submitAction)
        
        present(ac1, animated: true)
        
        
    }
    
    //Function to create alert for meme text at the bottom
    func memeTextBottom(topText : String?) {
        let ac1 = UIAlertController(title: "Text at the bottom", message: nil, preferredStyle: .alert)
        ac1.addTextField()

        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned ac1] _ in
            let answer = ac1.textFields![0]
            //Function call to create meme picture from Core Graphics
            self.drawMeme(topText: topText, bottomText: answer.text)
        }

        ac1.addAction(submitAction)

        present(ac1, animated: true)
        
    }
    
    //Function is called internally when image is chosen from picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        //Function call to memeTextTop
        memeTextTop()
        
    }
    
    //Function to create meme from Core Graphics
    func drawMeme(topText : String? , bottomText: String?){
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1000, height: 1000))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            //Create paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs : [NSAttributedString.Key : Any] = [
                .font : UIFont.boldSystemFont(ofSize: 40),
                .paragraphStyle : paragraphStyle,
                    
            ]
            //Draw the image
            let meme = images[0]
            meme.draw(at: CGPoint(x: 0, y: 0))
            
            //Draw the top text
            let attributedString1 = NSAttributedString(string: topText ?? "", attributes: attrs)
            attributedString1.draw(with: CGRect(x: 10, y: 32, width: 500, height: 100), options: .usesLineFragmentOrigin, context: nil)
            
            //Draw the bottom text
            let attributedString2 = NSAttributedString(string: bottomText ?? "", attributes: attrs)
            attributedString2.draw(with: CGRect(x: 10, y: 850, width: 500, height: 100), options: .usesLineFragmentOrigin, context: nil)
            
            
        }
        //Set image
        images[0] = image
        //reload collection view
        collectionView.reloadData()
    }
    
    //Function is called internally when we select an item from collection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailViewController
        vc?.tempImage = images[indexPath.item]
        navigationController?.pushViewController(vc!, animated: true)
        
    }
}

