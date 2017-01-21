//
//  AudioOutTestViewController.swift
//  Sound Transfer
//
//  Created by Cassidy Wang on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit

class AudioOutTestViewController: UIViewController {
    
    @IBOutlet weak var broadcastField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var freqInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func playSound() {
        if let freq = Int(broadcastField.text!) {
            
        } else {
            
        }
    }
    
    @IBAction func listen() {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
