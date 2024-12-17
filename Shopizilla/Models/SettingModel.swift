//
//  SettingModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 29/04/2022.
//

import UIKit

class SettingModel {
    
    let title: String
    let items: [(name: String, symbol: String)]
    
    init(title: String, items: [(name: String, symbol: String)]) {
        self.title = title
        self.items = items
    }
    
    static func shared() -> [SettingModel] {
        let notifs = [
            (name: "Messages".localized(), symbol: "messages-"),
            (name: "Order Updates".localized(), symbol: "orderUpdates-"),
            (name: "New Arrivals".localized(), symbol: "newArrivals-"),
            (name: "Promotions".localized(), symbol: "promotions-"),
            (name: "Sales Alerts".localized(), symbol: "salesAlerts-"),
        ]
        let socials = [(name: "Instagram", symbol: "instagram-")]
        let aboutUs = [
            (name: "About Us".localized(), symbol: "aboutUs-"),
            (name: "Information".localized(), symbol: "information-"),
            (name: "Support".localized(), symbol: "support-"),
        ]
        let shares = [
            (name: "Review".localized(), symbol: "review-"),
            (name: "Share".localized(), symbol: "share-"),
        ]
        
        return [
            SettingModel(title: "Push Notifications".localized(), items: notifs),
            SettingModel(title: "Socials".localized(), items: socials),
            SettingModel(title: "".localized(), items: aboutUs),
            SettingModel(title: "".localized(), items: shares),
        ]
    }
}
