//
//  LocalizeModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 21/02/2023.
//

import UIKit

//MARK: - Default Language
public let languageCodeKey = "DefaultLanguageCodeKey"
func getLanguageCode() -> String {
    return defaults.string(forKey: languageCodeKey) ?? "en"
}

func setLanguageCode(code: String) {
    defaults.set(code, forKey: languageCodeKey)
}

func arabicLanguage() -> Bool {
    return getLanguageCode() == "ar"
}

class LocalizeModel {
    
    let name: String
    let code: String
    var isSelect: Bool = false
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
        
        self.isSelect = getLanguageCode() == self.code
    }
    
    static func shared() -> [LocalizeModel] {
        return [
            LocalizeModel(name: "English", code: "en"),
            LocalizeModel(name: "Arabic", code: "ar"),
            LocalizeModel(name: "Vietnamese", code: "vi"),
        ]
    }
}
