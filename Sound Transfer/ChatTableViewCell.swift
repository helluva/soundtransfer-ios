//
//  ChatTableViewCell.swift
//  Sound Transfer
//
//  Created by Cassidy Wang on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    func setLabel(_ customText: String) {
        messageLabel.text = customText
    }

}
