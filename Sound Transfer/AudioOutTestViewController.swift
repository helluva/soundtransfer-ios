//
//  AudioOutTestViewController.swift
//  Sound Transfer
//
//  Created by Cassidy Wang on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import AudioKit

class AudioOutTestViewController: UIViewController {
    
    @IBOutlet weak var broadcastField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    var oscillator = AKOscillator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AudioKit.output = oscillator
        AudioKit.start()
    }
    
    @IBAction func toggleSound() {
        if oscillator.isPlaying {
            oscillator.stop()
            playButton.setTitle("Start sound", for: .normal)
        }
        
        else {
            oscillator.amplitude = 1
            oscillator.start()
            
            playEncodedAudio(for: "SH17")
            
            playButton.setTitle("Stop sound", for: .normal)
        }
    }
    
    func playEncodedAudio(for data: SoundConvertible) {
        let frequencies = data.frequencies
        var currentIndex = 0
        
        print(frequencies)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
            
            if currentIndex >= frequencies.count {
                self.toggleSound()
                timer.invalidate()
                return
            }
            
            let frequency = frequencies[currentIndex]
            currentIndex += 1
            
            self.oscillator.frequency = Double(frequency)
            
        })
        
        timer.fire()
        
        
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
