//
//  MenuModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/04/2022.
//

import UIKit

class MenuItem {
    
    let item: String
    let image: UIImage?
    let symbol: String //Dùng để xác nhận Item nào
    
    init(item: String, image: UIImage?, symbol: String) {
        self.item = item
        self.image = image
        self.symbol = symbol
    }
}

class MenuModel {
    
    let section: String
    var items: [MenuItem]
    let symbol: String //Dùng để xác nhận Section nào
    
    init(section: String, items: [MenuItem], symbol: String) {
        self.section = section
        self.items = items
        self.symbol = symbol
    }
}

//MARK: - Data

extension MenuModel {
    
    static func shared() -> [MenuModel] {
        let categories: [MenuItem] = [
            MenuItem(item: CategoryKey.NewArrivals.rawValue, image: UIImage(named: "leftMenu-newArrivals"), symbol: "newArrivals-"),
            MenuItem(item: CategoryKey.Men.rawValue, image: UIImage(named: "leftMenu-men"), symbol: "men-"),
            MenuItem(item: CategoryKey.Women.rawValue, image: UIImage(named: "leftMenu-women"), symbol: "women-"),
            MenuItem(item: CategoryKey.Accessories.rawValue, image: UIImage(named: "leftMenu-accessories"), symbol: "accessories-"),
        ]
        let socials: [MenuItem] = [
            MenuItem(item: "Instagram", image: UIImage(named: "leftMenu-instagram"), symbol: "instagram-"),
            MenuItem(item: "About Us".localized(), image: UIImage(named: "leftMenu-aboutUs"), symbol: "aboutUs-"),
            MenuItem(item: "Information".localized(), image: UIImage(named: "leftMenu-information"), symbol: "information-"),
            MenuItem(item: "Support".localized(), image: UIImage(named: "leftMenu-support"), symbol: "support-"),
        ]
        let logout: [MenuItem] = [
            MenuItem(item: "Login".localized(), image: UIImage(named: "leftMenu-signIn"), symbol: "signIn-")
        ]
        
        return [
            MenuModel(section: "Category".localized(), items: categories, symbol: "category-"),
            MenuModel(section: "Social".localized(), items: socials, symbol: "social-"),
            MenuModel(section: "Feature".localized(), items: logout, symbol: "feature-"),
        ]
    }
}
