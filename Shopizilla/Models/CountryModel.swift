//
//  CountryModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 16/05/2022.
//

import UIKit

struct CountryModel {
    
    let id: Int
    let name: String
    let code: String
    var states: [State]
}

class Country {
    
    private let model: CountryModel
    
    var id: Int { return model.id }
    var name: String { return model.name }
    var code: String { return model.code }
    var states: [State] { return model.states }
    
    init(model: CountryModel) {
        self.model = model
    }
}

extension Country {
    
    convenience init(dict: NSDictionary) {
        let id = dict["id"] as? Int ?? 0
        let name = dict["name"] as? String ?? ""
        let code = dict["iso2"] as? String ?? ""
        
        var states: [State] = []
        if let array = dict["states"] as? NSArray {
            states = array.map({ State(dict: $0 as! NSDictionary) })
        }
        
        let model = CountryModel(id: id, name: name, code: code, states: states)
        self.init(model: model)
    }
}
