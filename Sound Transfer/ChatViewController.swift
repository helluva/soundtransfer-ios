//
//  ChatViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit
import AudioKit

class ChatViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    
    var oscillator = AKOscillator()
    var previousMessages: [String] = []
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioKit.stop()
        self.oscillator.stop()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
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
    
    @IBAction func sendMessage() {
        let message = messageField.text!
        let frequencies = message.frequencies
        var currentIndex = 0
        
        print(frequencies)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { timer in
            
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
        
        previousMessages.append(message)
    }
}
