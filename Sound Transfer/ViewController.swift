//
//  ViewController.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/20/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(String(cString: helloWorld()))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
