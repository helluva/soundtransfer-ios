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
    
    var length: Int32 = 0;
    var dataPointer: UnsafeMutablePointer<UInt8>? = nil
    
    
    override func viewDidLoad() {
        
        initialize_decoder(&length, &dataPointer)
        
        //prepare microphone
        let highPass = AKHighPassFilter(mic, cutoffFrequency: 1000, resonance: 0)
        highPass.start()
        let tracker = AKFrequencyTracker.init(highPass, hopSize: 200, peakCount: 2000)
        
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: (1.0/35.0), repeats: true, block: { _ in
            let frequency = tracker.frequency;
            
            receive_frame(frequency)
            
            if let dataPointer = self.dataPointer {
                print(Data.fromPointer(dataPointer).bytes)
            } else {
                print("--")
            }
            
            
        })
        
    }
    
    
}
