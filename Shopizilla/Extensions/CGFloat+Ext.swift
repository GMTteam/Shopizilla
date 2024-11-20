//
//  CGFloat+Ext.swift
//  Solitaire
//
//  Created by Jack Ily on 02/06/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

public let π = CGFloat.pi

extension CGFloat {
    
    func degreesToRadians() -> CGFloat {
        return self * π / 180
    }
    
    func radiansToDegrees() -> CGFloat {
        return self * 180 / π
    }
    
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }
    
    func pointsToPixels() -> CGFloat {
        return self * UIScreen.main.scale
    }
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
