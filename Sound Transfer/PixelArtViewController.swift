//
//  PixelArtViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit

class PixelArtViewController : UIViewController {
    
    @IBOutlet weak var pixels: UIStackView!
    @IBOutlet weak var colorPicker: UIStackView!
    
    
    
    
    override func viewDidLoad() {
        self.selectColor(self.currentColorButton)
    }
    
    
    //MARK: - Interacting with pixels
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch(at: touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch(at: touches.first!)
    }
    
    func touch(at touch: UITouch) {
        
        let locationInView = touch.location(in: self.view)
        
        for subview in pixels.arrangedSubviews {
            guard let verticalStackView = subview as? UIStackView else { continue }
            for pixel in verticalStackView.arrangedSubviews {
                
                let locationInPixel = self.view.convert(locationInView, to: pixel)
                if pixel.bounds.contains(locationInPixel) {
                    pixel.backgroundColor = self.currentColor
                    pixel.tag = self.currentColorIndex
                }
                
            }
        }
    }
    
    
    //MARK: - Color Management
    
    var currentColorIndex = 1
    
    var currentColorButton: UIView {
        return colorPicker.arrangedSubviews.first(where: { $0.tag == currentColorIndex })!
    }
    
    var currentColor: UIColor {
        return currentColorButton.backgroundColor!
    }
    
    @IBAction func selectColor(_ sender: UIView) {
        
        self.currentColorIndex = sender.tag
        
        for subview in colorPicker.arrangedSubviews {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
            
                if subview == sender {
                    subview.transform = CGAffineTransform.init(translationX: 0, y: -10);
                } else {
                    subview.transform = .identity
                }
                
            }, completion: nil)
            
        }
        
    }
    
    
    //MARK : - Output
    
    @IBAction func sendPressed(_ sender: Any) {
        
        let count = 8*8
        let flatColors = UnsafeMutablePointer<Int8>.allocate(capacity: count)
        var currentIndex = 0
        
        for subview in self.pixels.arrangedSubviews {
            for pixel in (subview as? UIStackView)?.arrangedSubviews ?? [] {
                flatColors.advanced(by: currentIndex).pointee = Int8(pixel.tag)
                print("\(pixel.tag), ", separator: "", terminator: "")
                currentIndex += 1
            }
        }
        
        guard let frequenciesPointer = freqs_from_color(flatColors, Int32(count)) else { return }
        
        var frequencies = [Int]()
        
        for i in 0 ..< (count / 4) {
            let pointer = frequenciesPointer.advanced(by: i)
            frequencies.append(Int(pointer.pointee))
        }
        
        print(frequencies)
        
    }
    
    
}
