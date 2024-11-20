//
//  StatusModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 22/06/2022.
//

import Foundation

class StatusModel {
    
    let title: String
    let index: Int
    
    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
    
    static func shared() -> [StatusModel] {
        return [
            StatusModel(title: "Order Placed".localized(), index: 0),
            StatusModel(title: "On Going".localized(), index: 1),
            StatusModel(title: "Delivered".localized(), index: 2),
            StatusModel(title: "Cancelled".localized(), index: 3)
        ]
    }
}
