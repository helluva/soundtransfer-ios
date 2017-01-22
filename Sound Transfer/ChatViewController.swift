//
//  ChatViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import AudioKit
import MediaPlayer

class ChatViewController : UIViewController, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var oscillator = AKOscillator()
    var mic = AKMicrophone()
    var previousMessages: [(originatedFromThisDevice: Bool, message: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageField.layer.borderColor = UIColor.gray.cgColor
        messageField.layer.borderWidth = 1.0
        messageField.layer.cornerRadius = 5.0
        
        hideKeyboardOnTap()
        addKeyboardNotifications()
        
        oscillator.amplitude = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if animated {
            AudioKit.stop()
            self.inputTimer?.invalidate()
        }
        
        self.setupInput()
    }
    
    
    //MARK: - Keyboard and Text View
    
    func textViewDidChange(_ textView: UITextView) {
        if messageField.text != "" {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        //Adjust view according to keyboard size
        let userInfo = notification.userInfo!
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        //Establishes location of top of keyboard relative to view coordinates
        bottomAnchor.constant = keyboardEndFrame!.height + 10
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomAnchor.constant = 10.0
    }
    
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! ChatTableViewCell
        cell.setLabel(previousMessages[index])
        return cell
    }
    
    func reloadTable() {
        messageTableView.reloadData()
        
        let lastIndex = previousMessages.count - 1
        let indexPath = IndexPath(item: lastIndex, section: 0)
        if lastIndex > 0 {
            messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    //MARK: - Sound Input
    
    var length: Int32 = 0;
    var dataPointer: UnsafeMutablePointer<UInt8>? = nil
    var inputTimer: Timer?
    
    var pixelArtController: PixelArtViewController?
    
    func setupInput() {
        
        //reset state
        initialize_decoder(&length, &dataPointer)
        self.pixelArtController = nil
        
        //prepare microphone
        self.setDeviceSoundVolume(to: 0)
        let tracker = AKFrequencyTracker(mic, hopSize: 20, peakCount: 2000)
        
        AudioKit.output = tracker
        AudioKit.start()
        
        
        var started:Bool = false
        self.inputTimer = Timer.scheduledTimer(withTimeInterval: (1.0/36.0), repeats: true, block: { _ in
            let frequency = tracker.frequency;
            let status = receive_frame(frequency)
            
            
            if let dataPointer = self.dataPointer, status == -2 || status == -5 {
                
                
                //IMAGE! I LOVE MAGIC NUMBERS!!!!! (32 + 5) * 2
                print("length: \(self.length)")
                if self.length == 42 {
                    
                    if let pixelArtController = self.pixelArtController {
                        let byteCount = Int(self.length / 2)
                        
                        var allBytes = [Int]()
                        for i in 0 ..< byteCount {
                            let byte = dataPointer.advanced(by: i).pointee
                            allBytes.append(Int(byte))
                        }
                        
                        pixelArtController.displayBytes(allBytes)
                    }
                    
                        
                    else { //if pixelArtController == nil
                        self.pixelArtController = PixelArtViewController.presentForInput(from: self)
                    }
                }
                
                else {
                    let data = Data(bytes: dataPointer, count: Int(self.length / 2))
                    
                    let optionalString = String(data: data, encoding: .utf8)
                    let string = optionalString ?? self.previousMessages.last?.message ?? "..."
                    print(string)
                    
                    if !started {
                        print("starting")
                        self.previousMessages.append((false, string))
                        self.reloadTable()
                        started = true
                    } else {
                        print("updating")
                        self.previousMessages[self.previousMessages.count - 1] = (false, string)
                        self.reloadTable()
                    }
                }

            }
            
            if status == 0 { // 0 is "TRANSFER_COMPLETE"
                initialize_decoder(&self.length, &self.dataPointer)
                started = false
            }
            
        })
        
    }
    
    func setDeviceSoundVolume(to volume: Float) {
        //ignore request on phone -- this is only a problem on the iPad
        if UIDevice.current.userInterfaceIdiom == .phone { return }
        
        (MPVolumeView().subviews.filter{ NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as? UISlider)?.setValue(volume, animated: false)
    }
    
    
    //MARK: - Sound Output
    
    @IBAction func sendMessage() {
        
        var message = messageField.text!
        if message.characters.count == 16 {
            message.append(" ")
        }
        var frequencies = message.frequencies
        
        print(frequencies)
        
        let noteDict: [String: Int] = ["C6": 1046, "C#6": 1108, "D6": 1174, "D#6": 1244, "E6": 1318, "F6": 1396, "F#6": 1480, "G6": 1568, "G#6": 1661, "A6": 1760, "A#6": 1864, "B6": 1975, "C7": 2093, "C#7": 2217, "D7": 2349, "D#7": 2489, "E7": 2637, "F7": 2794, "E8": 5274, "N": 0]
        
        if message == "For Elise" {
            
            let noteFrequencies = ["E7", "D#7", "E7", "D#7", "E7", "B6", "D7", "C7", "A6", "A6", "A6", "C6", "E6", "A6", "B6", "B6", "B6", "E6", "G#6", "B6", "C7", "C7", "C7", "E6", "E7", "D#7", "E7", "D#7", "E7", "B6", "D7", "C7", "A6", "A6", "A6", "C6", "E6", "A6", "B6", "B6", "B6", "E6", "C7", "B6", "A6", "A6", "A6", "B6", "C7", "D7", "E7", "E7", "E7", "G6", "F7", "E7", "D7", "D7", "D7", "F6", "E7", "D7", "C7", "C7", "C7", "E6", "D7", "C7", "B6", "B6", "B6", "E6", "E6", "E7", "E6", "E7", "E7", "E8", "D#7", "E7", "D#7", "E7", "D#7", "E7", "D#7", "E7", "D#7", "E7", "D#7", "E7", "B6", "D7", "C7", "A6", "A6", "A6", "C6", "E6", "A6", "B6", "B6", "B6", "E6", "C7", "B6", "A6", "A6", "A6"]
            
            frequencies = []
            for note in noteFrequencies {
                frequencies.append(noteDict[note]! as Int)
            }
        } else if message == "Mario" {
            let noteFrequencies = ["E7", "E7", "N", "E7", "N", "C7", "E7", "N", "G7", "N", "N", "N", "G6", "N", "N", "N", "C7", "N", "N", "G6", "N", "N", "E6", "N", "N", "A6", "N", "B6", "N", "A#6", "A6", "G6", "E7", "G7", "A7", "N", "F7", "G7", "N", "E7", "N", "C7", "D7", "B6"]
            
            frequencies = []
            for note in noteFrequencies {
                frequencies.append(noteDict[note]! as Int)
            }
        }
        
        sendFrequencies(frequencies, contentForTable: message)
    }
    
    
    func sendFrequencies(_ freqs: [Int], contentForTable: String) {
        
        //stop listening
        AudioKit.stop()
        self.inputTimer?.invalidate()
        
        //start outputing
        self.setDeviceSoundVolume(to: 1)
        AudioKit.output = oscillator
        AudioKit.start()
        
        var currentIndex = 0
        var firstFrequencyExtension = 8
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { timer in
            
            if currentIndex >= freqs.count {
                timer.invalidate()
                self.oscillator.stop()
                AudioKit.stop()
                
                self.setupInput()
                
                return
            }
            
            let frequency = freqs[currentIndex]
            self.oscillator.frequency = Double(frequency)
            if currentIndex == 0 {
                self.oscillator.start()
            }
            
            currentIndex += 1
            
            if firstFrequencyExtension > 0 {
                firstFrequencyExtension -= 1
                currentIndex -= 1
            }
        })
        
        messageField.text = ""
        sendButton.isEnabled = false
        previousMessages.append((true, contentForTable))
        self.resignFirstResponder()
        reloadTable()
        
    }
    
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let pixelVC = segue.destination as? PixelArtViewController {
            pixelVC.chatViewController = self
        }
    }
    
}
