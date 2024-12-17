//
//  CityModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 16/05/2022.
//

import UIKit

struct CityModel {
    
    let id: Int
    let name: String
    var wards: [Ward] = []
}

class City {
    
    private let model: CityModel
    
    var id: Int { return model.id }
    var name: String { return model.name }
    var wards: [Ward] { return model.wards }
    
    init(model: CityModel) {
        self.model = model
    }
}

extension City {
    
    convenience init(dict: NSDictionary) {
        let id = dict["id"] as? Int ?? 0
        let name = dict["name"] as? String ?? ""
        
        let model = CityModel(id: id, name: name)
        self.init(model: model)
    }
    
    convenience init(vnDict: NSDictionary) {
        let name = vnDict["name_with_type"] as? String ?? ""
        
        var wards: [Ward] = []
        if let dict = vnDict["xa-phuong"] as? NSDictionary {
            wards = dict.allValues.map({ Ward(vnDict: $0 as! NSDictionary) })
        }
        
        let model = CityModel(id: 0, name: name, wards: wards)
        self.init(model: model)
    }
}
