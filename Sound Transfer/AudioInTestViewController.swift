//
//  AudioInTestViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import AudioKit

class AudioInTestViewController : UIViewController {
    
    var mic = AKMicrophone()
    
    
    override func viewDidLoad() {
        
        let highPass = AKHighPassFilter(mic, cutoffFrequency: 1000, resonance: 0)
        highPass.start()
        let tracker = AKFrequencyTracker.init(highPass, hopSize: 200, peakCount: 2000)
        
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true, block: { _ in
            print(tracker.frequency)
        })
        
    }
    
    
}
