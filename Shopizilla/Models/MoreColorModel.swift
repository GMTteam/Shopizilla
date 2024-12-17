//
//  MoreColorModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 12/06/2022.
//

import UIKit

class MoreColor {
    
    let productUID: String //UID chứ ko phải productID
    let color: String
    
    init(productUID: String, color: String) {
        self.productUID = productUID
        self.color = color
    }
}
