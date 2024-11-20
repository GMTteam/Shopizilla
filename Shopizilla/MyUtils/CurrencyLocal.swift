//
//  CurrencyLocal.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 07/06/2022.
//

import UIKit

class CurrencyModel: NSObject {
    
    static let shared = CurrencyModel()
    
    enum CountryCode: String {
        case US, VN
    }
    
    ///Quốc Gia mặc định là US
    var countryCode: CountryCode = .US
    
    ///Đơn vị tiền tệ của Quốc Gia
    func currency() -> String {
        var txt = "USD"
        
        switch countryCode {
        case .US: txt = "USD"
        case .VN: txt = "đ"
        }
        
        return txt
    }
}
