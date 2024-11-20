//
//  UISearchBar+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 23/11/2021.
//

import UIKit

internal extension UISearchBar {
    
    func customFontSearchBar() {
        self[keyPath: \.searchTextField].font = UIFont(name: FontName.ppRegular, size: 16.0)
        self[keyPath: \.searchTextField].backgroundColor = UIColor(hex: 0xFAFAFF)
        self[keyPath: \.searchTextField].placeholder = "Search".localized()
        
        self.setValue("Cancel".localized(), forKey: "cancelButtonText")
        self.searchBarStyle = .minimal
        self.returnKeyType = .search
    }
}
