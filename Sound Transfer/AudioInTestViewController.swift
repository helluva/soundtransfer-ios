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
        
        initialize() //initialize c code
        
        //prepare microphone
        let highPass = AKHighPassFilter(mic, cutoffFrequency: 1000, resonance: 0)
        highPass.start()
        let tracker = AKFrequencyTracker.init(highPass, hopSize: 200, peakCount: 2000)
        
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: (1.0/35.0), repeats: true, block: { _ in
            let frequency = tracker.frequency;
            
            let cOutput = frame(frequency, nil)
            print(cOutput)
        })
        
    }
    
    
}
