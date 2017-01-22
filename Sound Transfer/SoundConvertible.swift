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
    
    var bytes: [UInt8] {
        return self.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: self.count))
        }
    }
    
    var frequencies : [Int] {
        let bytePointer: UnsafePointer<Int8>? = self.withUnsafeBytes { $0 }
        
        let withoutSeparators = freqs_from_input(bytePointer, Int32(self.bytes.count))
        let outputFrequencies = separate_repeating_freqs(withoutSeparators, Int32(self.bytes.count) * 2 + 5)
        
        guard let frequenciesPointer = outputFrequencies else {
            return []
        }
        
        let count = malloc_size(frequenciesPointer) / 4 //4 = sizeof(int)
        print(self.bytes)
        var frequencies = [Int]()
        
        for i in 0 ..< count {
            let pointer = frequenciesPointer.advanced(by: i)
            frequencies.append(Int(pointer.pointee))
        }
        
        return frequencies
    }
    
}


extension String : SoundConvertible {
    
    var frequencies: [Int] {
        return self.data(using: .utf8)!.frequencies
    }
    
}


