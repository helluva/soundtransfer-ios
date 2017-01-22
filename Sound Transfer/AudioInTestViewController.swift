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
        
        print("attempting to stop")
        AudioKit.stop()
        print("stopped")
        
        //prepare microphone
        print("creating mic")
        mic = AKMicrophone()
        print("created mic")
        let tracker = AKFrequencyTracker(mic, hopSize: 20, peakCount: 2000)
        
        print("setting output")
        AudioKit.output = tracker
        print("restarting")
        AudioKit.start()
        print("done")
        
        Timer.scheduledTimer(withTimeInterval: (1.0/36.0), repeats: true, block: { _ in
            let frequency = tracker.frequency;
            
            //print(frequency)
            
            receive_frame(frequency)
            
            if let dataPointer = self.dataPointer {
                
                //print(self.length)
                
                let data = Data(bytes: dataPointer, count: Int(self.length / 2))
                //print(self.length)
                //print("length: \(self.length / (8 / BITS_PER_TONE))   bytes: \(data.bytes)")
                
                /*let characters = data.bytes.map({ byte -> String in
                    let char = Data(bytes: [byte])
                    return String(data: char, encoding: .utf8) ?? "_"
                })*/
                
                let string = String(data: data, encoding: .utf8)
                print(string ?? "--")
                
            } else {
                //print("--")
            }
            
        })
        
    }
    
    
}
