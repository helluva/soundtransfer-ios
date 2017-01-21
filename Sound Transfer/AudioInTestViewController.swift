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
        let tracker = AKFrequencyTracker(mic, hopSize: 128, peakCount: 20)
        
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: (1.0/32.0), repeats: true, block: { _ in
            let frequency = tracker.frequency;
            
            //print(frequency)
            
            receive_frame(frequency)
            
            if let dataPointer = self.dataPointer {
                let received = String(data: Data.fromPointer(dataPointer), encoding: .utf8)
                print(received)
            } else {
                print("--")
            }
            
            
        })
        
    }
    
    
}
