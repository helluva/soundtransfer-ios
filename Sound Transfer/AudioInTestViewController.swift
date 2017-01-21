//
//  AudioInTestViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import AVFoundation

let audioQueue = DispatchQueue(label: "Audio Queue")

class AudioInTestViewController : UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession!
    
    override func viewDidLoad() {
        //subscribe to notifications
        for notification in [NSNotification.Name.AVCaptureSessionDidStartRunning,
                             NSNotification.Name.AVCaptureSessionRuntimeError,
                             NSNotification.Name.AVCaptureSessionDidStopRunning] {
            NotificationCenter.default.addObserver(forName: notification, object: nil, queue: nil, using: { received in
                print("\(received.name.rawValue): \(received.userInfo)")
            })
        }

        //set up capture session
        self.session = AVCaptureSession()
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        let input = try! AVCaptureDeviceInput(device: device)
        session?.addInput(input)
        
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: audioQueue)
        session?.addOutput(output)
        
        session?.startRunning()
    }
    
    
    //MARK: - AVCaptureAudioDataOutputSampleBufferDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else { return }
        
        var dataPointer: UnsafeMutablePointer<Int8>? = nil
        
        var length = CMBlockBufferGetDataLength(blockBuffer)
        CMBlockBufferGetDataPointer(blockBuffer, 0, &length, &length, &dataPointer)
        
        print(dataPointer!.pointee)
    }
    
}
