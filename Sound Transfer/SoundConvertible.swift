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
    
    var bytes: [Int8] {
        return self.withUnsafeBytes {
            [Int8](UnsafeBufferPointer(start: $0, count: self.count))
        }
    }
    
    var frequencies : [Int] {
        let bytePointer: UnsafePointer<Int8>! = self.withUnsafeBytes { $0 }
        
        guard let frequenciesPointer = freqs_from_input(bytePointer, Int32(self.bytes.count)) else {
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
    
    static func fromPointer(_ pointer: UnsafeMutablePointer<UInt8>) -> Data {
        return Data(bytes: pointer, count: 4)
    }
    
}

extension String : SoundConvertible {
    
    var frequencies: [Int] {
        return self.data(using: .utf8)!.frequencies
    }
    
}


