//
//  ShareModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/05/2022.
//

import UIKit

class ShareModel {
    
    let title: String
    let image: UIImage?
    let index: Int
    
    init(title: String, image: UIImage?, index: Int) {
        self.title = title
        self.image = image
        self.index = index
    }
    
    static func shared() -> [ShareModel] {
        return [
            ShareModel(title: "Copy Link".localized(), image: UIImage(named: "share-copyLink"), index: 0),
            ShareModel(title: "Via Text".localized(), image: UIImage(named: "share-viaText"), index: 1),
            ShareModel(title: "More".localized(), image: UIImage(named: "share-more"), index: 2),
            //ShareModel(title: "Via Contacts", image: UIImage(named: "share-viaContact")),
        ]
    }
}
