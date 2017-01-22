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
    
    var mic: AKMicrophone!
    
    var length: Int32 = 0;
    var dataPointer: UnsafeMutablePointer<UInt8>? = nil
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        initialize_decoder(&length, &dataPointer)
        
        //prepare microphone
        mic = AKMicrophone()
        let tracker = AKFrequencyTracker(mic, hopSize: 20, peakCount: 2000)
        
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: (1.0/32.0), repeats: true, block: { _ in
            let frequency = tracker.frequency;
            
            //print(frequency)
            
            receive_frame(frequency)
            
            if let dataPointer = self.dataPointer {
                let data = Data(bytes: dataPointer, count: Int(self.length) / 4)
                //print(data.bytes)
                
                let characters = data.bytes.map({ byte -> String in
                    let char = Data(bytes: [byte])
                    return String(data: char, encoding: .utf8) ?? "_"
                })

                //print(characters)
                
            } else {
                //print("--")
            }
            
        })
        
    }
    
    
}
