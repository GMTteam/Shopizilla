//
//  StateModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 16/05/2022.
//

import Foundation

struct StateModel {
    
    let id: Int
    let name: String
    var cities: [City]
}

class State {
    
    private let model: StateModel
    
    var id: Int { return model.id }
    var name: String { return model.name }
    var cities: [City] { return model.cities }
    
    init(model: StateModel) {
        self.model = model
    }
}

extension State {
    
    convenience init(dict: NSDictionary) {
        let id = dict["id"] as? Int ?? 0
        let name = dict["name"] as? String ?? ""
        
        var cities: [City] = []
        if let array = dict["cities"] as? NSArray {
            cities = array.map({ City(dict: $0 as! NSDictionary) })
        }
        
        let model = StateModel(id: id, name: name, cities: cities)
        self.init(model: model)
    }
    
    convenience init(vnDict: NSDictionary) {
        let name = vnDict["name"] as? String ?? ""
        
        var cities: [City] = []
        if let dict = vnDict["quan-huyen"] as? NSDictionary {
            cities = dict.allValues.map({ City(vnDict: $0 as! NSDictionary) })
        }
        
        let model = StateModel(id: 0, name: name, cities: cities)
        self.init(model: model)
    }
}
