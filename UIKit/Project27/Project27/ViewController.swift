//
//  ViewController.swift
//  Project27
//
//  Created by Sahil Satralkar on 27/10/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Default view as rectangle
        drawRectange()
        
    }

    //Action for the button Redraw
    @IBAction func redrawTapped(_ sender: UIButton) {
        
        //COunter to track number of taps
        currentDrawType += 1
        
        //Keep the counter limited to 7 then reset
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        //Switch case call the draw method for each case
        switch currentDrawType {
        case 0:
            drawRectange()
        case 1:
            drawCircle()
        case 2 :
            drawCheckerboard()
        case 3 :
            drawRotatedSquares()
        case 4 :
            drawLines()
        case 5 :
            drawImagesAndText()
        case 6 :
            drawSmiley()
        case 7 :
            drawTwin()
        default:
            break
        }
    }
    
    //Method to draw TWIN on screen
    func drawTwin() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            
            //Black color sstroke with width 5
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            //Draw T letter
            ctx.cgContext.move(to: CGPoint(x: 50, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 80, y: 50))
            
            ctx.cgContext.move(to: CGPoint(x: 65, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 65, y: 100))
            
            
            //Draw W letter
            ctx.cgContext.move(to: CGPoint(x: 90, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 100, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 110, y: 50))
            
            ctx.cgContext.move(to: CGPoint(x: 110, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 120, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 120, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 130, y: 50))
            
            
            //Draw I letter
            ctx.cgContext.move(to: CGPoint(x: 140, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 140, y: 100))
            
            
            //Draw N letter
            ctx.cgContext.move(to: CGPoint(x: 150, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 150, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 150, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 180, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 100))
            
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        //Set image to UIImageView
        imageView.image = image
    }
    
    //Function to draw smiley
    func drawSmiley(){
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            //drawing code
            let rectangle = CGRect(x: 20, y: 20, width: 450, height: 450)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            ctx.cgContext.addEllipse(in: rectangle)
            
            let eyes1 = CGRect(x: 100, y: 90, width: 80, height: 80)
            let eyes2 = CGRect(x: 320, y: 90, width: 80, height: 80)
            //let mouth = CGRect(x: 190, y: 240, width: 180, height: 180)
            ctx.cgContext.addEllipse(in: eyes2)
            ctx.cgContext.addEllipse(in: eyes1)
            
            ctx.cgContext.move(to: CGPoint(x: 340, y: 300))
            ctx.cgContext.addArc(center: CGPoint(x: 240, y: 300), radius: 100, startAngle: .zero, endAngle: .pi, clockwise: false)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            
        }
        imageView.image = image
        
    }
    
    //Function to draw an image and text
    func drawImagesAndText() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs : [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: 36),
                .paragraphStyle : paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            
        }
        imageView.image = image
        
    }
    
    //Function to draw linse
    func drawLines() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length : CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                    
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
        
    }
    
    //Function to draw rotating squares
    func drawRotatedSquares() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor((UIColor.black.cgColor))
            ctx.cgContext.strokePath()
            
        }
        imageView.image = image
        
    }
    
    //function to draw a checkerboard
    func drawCheckerboard() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col*64, y: row*64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = image
        
    }
    
    //Function to draw rectangle
    func drawRectange() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            //drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        imageView.image = image
    }
    
    //Function to draw circle
    func drawCircle() {
        
        //Create a UIGraphicsImageRenderer object with given size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //Create an image from renderer with closure and pass in context
        let image = renderer.image {
            ctx in
            //drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        
        }
        imageView.image = image
    }
    
}

