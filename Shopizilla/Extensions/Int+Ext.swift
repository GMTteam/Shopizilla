//
//  Int+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 25/11/2021.
//

import Foundation

extension Int {
    
    static func random(min: Int, max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    static func random(_ n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(abs(n))))
    }
    
    static func random(range: ClosedRange<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
    }
}
