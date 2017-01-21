//
//  ViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/20/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import CoreAudio

class ViewController: UIViewController {

    @IBOutlet weak var broadcastField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(String(cString: helloWorld()))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSound() {
        listenButton.isEnabled = false
        
        
        
        listenButton.isEnabled = true
    }

}

