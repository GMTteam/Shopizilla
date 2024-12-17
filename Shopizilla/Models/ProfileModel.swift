//
//  ProfileModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/04/2022.
//

import UIKit

class ProfileModel {
    
    let title: String
    let image: UIImage?
    let index: Int
    
    init(title: String, image: UIImage?, index: Int) {
        self.title = title
        self.image = image
        self.index = index
    }
    
    static func shared() -> [ProfileModel] {
        return [
            ProfileModel(title: "Account Details".localized(), image: UIImage(named: "profile-accountDetails"), index: 0),
            ProfileModel(title: "Order History".localized(), image: UIImage(named: "profile-orderHistory"), index: 1),
            ProfileModel(title: "Wishlist".localized(), image: UIImage(named: "profile-wishlist"), index: 2),
            ProfileModel(title: "Chat".localized(), image: UIImage(named: "profile-chat"), index: 3),
            ProfileModel(title: "Address".localized(), image: UIImage(named: "profile-address"), index: 4),
            ProfileModel(title: "Notifications".localized(), image: UIImage(named: "profile-notification"), index: 5),
            ProfileModel(title: "Settings".localized(), image: UIImage(named: "profile-settings"), index: 6),
        ]
    }
}
