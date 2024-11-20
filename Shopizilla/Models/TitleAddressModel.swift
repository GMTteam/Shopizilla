//
//  TitleAddressModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 22/06/2022.
//

import Foundation

class TitleAddressModel {
    
    let title: String
    let symbol: String
    
    init(title: String, symbol: String) {
        self.title = title
        self.symbol = symbol
    }
    
    static func shared() -> [TitleAddressModel] {
        return [
            TitleAddressModel(title: "Full Name".localized(), symbol: "fullName-"),
            TitleAddressModel(title: "Street".localized(), symbol: "street-"),
            TitleAddressModel(title: "Country".localized(), symbol: "country-"),
            TitleAddressModel(title: "State/Province".localized(), symbol: "state-"),
            TitleAddressModel(title: "City/Town".localized(), symbol: "city-"),
            TitleAddressModel(title: "Ward/Village".localized(), symbol: "ward-"),
            TitleAddressModel(title: "Phone Number".localized(), symbol: "phoneNumber-"),
            TitleAddressModel(title: "".localized(), symbol: ""),
        ]
    }
}
