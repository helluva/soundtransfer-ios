//
//  OutputManager.swift
//  Sound Transfer
//
//  Created by Cal Stephens on 1/21/17.
//  Copyright © 2017 Helluva. All rights reserved.
//

import Foundation

protocol SoundConvertible {
    var frequencies: [Int] { get }
}

extension Data : SoundConvertible {
    
    var frequencies : [Int] {
        let bytes: UnsafePointer<Int32> = self.withUnsafeBytes { $0 }
        
        
        return []
        //freqs_from_input(bytes, bytes.length, output?)
        
    }
    
}

extension String : SoundConvertible {
    
    var frequencies: [Int] {
        return self.data(using: .utf8)!.frequencies
    }
    
}


