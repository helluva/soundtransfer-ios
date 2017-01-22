//
//  ChatViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import AudioKit

class ChatViewController : UIViewController, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var oscillator = AKOscillator()
    var previousMessages: [String] = []
    
    let noteDict: [String: Int] = ["C6": 1046, "C#6": 1108, "D6": 1174, "D#6": 1244, "E6": 1318, "F6": 1396, "F#6": 1480, "G6": 1568, "G#6": 1661, "A6": 1760, "A#6": 1864, "B6": 1975, "C7": 2093, "C#7": 2217, "D7": 2349, "D#7": 2489, "E7": 2637, "F7": 2794, "E8": 5274, "N": 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageField.layer.borderColor = UIColor.gray.cgColor
        messageField.layer.borderWidth = 1.0
        messageField.layer.cornerRadius = 5.0
        
        hideKeyboardOnTap()
        addKeyboardNotifications()
        
        oscillator.amplitude = 1
        AudioKit.output = oscillator
        AudioKit.start()
    }
    
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
    
    @IBAction func sendMessage() {
        var message = messageField.text!
        if message.characters.count == 35 {
            message.append(" ")
        }
        var frequencies = message.frequencies
        if message == "For Elise" {
            let noteFrequencies = ["E7", "D#7", "E7", "D#7", "E7", "B6", "D7", "C7", "A6", "A6", "A6", "C6", "E6", "A6", "B6", "B6", "B6", "E6", "G#6", "B6", "C7", "C7", "C7", "E6", "E7", "D#7", "E7", "D#7", "E7", "B6", "D7", "C7", "A6", "A6", "A6", "C6", "E6", "A6", "B6", "B6", "B6", "E6", "C7", "B6", "A6", "A6", "A6", "B6", "C7", "D7", "E7", "E7", "E7", "G6", "F7", "E7", "D7", "D7", "D7", "F6", "E7", "D7", "C7", "C7", "C7", "E6", "D7", "C7", "B6", "B6", "B6", "E6", "E6", "E7", "E6", "E7", "E7", "E8", "D#7", "E7", "D#7", "E7", "D#7", "E7", "D#7", "E7", "D#7", "E7", "D#7", "E7", "B6", "D7", "C7", "A6", "A6", "A6", "C6", "E6", "A6", "B6", "B6", "B6", "E6", "C7", "B6", "A6", "A6", "A6"]
            
            frequencies = []
            for note in noteFrequencies {
                frequencies.append(noteDict[note]! as Int)
            }
        }
        var currentIndex = 0
        
        print(frequencies)
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
            
            if currentIndex >= frequencies.count {
                timer.invalidate()
                self.oscillator.stop()
                return
            }
            
            let frequency = frequencies[currentIndex]
            self.oscillator.frequency = Double(frequency)
            if currentIndex == 0 {
                self.oscillator.start()
            }
            
            currentIndex += 1
        })
        
        messageField.text = ""
        sendButton.isEnabled = false
        previousMessages.append(message)
        self.resignFirstResponder()
        reloadTable()
    }
}
