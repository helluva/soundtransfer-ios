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
        
        let bytes = self.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: self.count))
        }
        
        return bytes.flatMap { byte -> [Int] in
            let pointer = freq_4_from_input(byte)
            
            func byteAt(_ offset: Int) -> Int {
                return Int(pointer!.advanced(by: offset).pointee)
            }
            
            let frequenciesForByte: [Int] = [byteAt(0), byteAt(1), byteAt(2), byteAt(3)]
            return frequenciesForByte
        }
        
    }
    
}

extension String : SoundConvertible {
    
    var frequencies: [Int] {
        return self.data(using: .utf8)!.frequencies
    }
    
}


