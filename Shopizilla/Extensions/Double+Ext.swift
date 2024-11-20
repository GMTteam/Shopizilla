//
//  Double+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 23/11/2021.
//

import UIKit

extension Formatter {
    
    static let withCurrency: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.groupingSeparator = "," //Dollar
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }()
    
    static let withDecimal: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "." //VND
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

extension Double {
    
    ///Dollar
    var formattedWithCurrency: String {
        guard let currency = Formatter.withCurrency.string(for: self) else { return "" }
        return "$" + currency
    }
    
    ///VND
    var formattedWithDecimal: String {
        guard let currency = Formatter.withDecimal.string(for: self) else { return "" }
        return currency + "đ"
    }
    
    ///Nếu quốc gia hiện tại là Việt Nam thì hiển thị tiền tệ sẽ khác.
    var formattedCurrency: String {
        return CurrencyModel.shared.countryCode == .VN ? formattedWithDecimal : formattedWithCurrency
    }
}
