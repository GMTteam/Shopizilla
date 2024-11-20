//
//  WardModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 17/05/2022.
//

import Foundation

struct WardModel {
    
    let nameWithType: String
}

class Ward {
    
    private let model: WardModel
    
    var nameWithType: String { return model.nameWithType }
    
    init(model: WardModel) {
        self.model = model
    }
}

extension Ward {
    
    convenience init(vnDict: NSDictionary) {
        let nameWithType = vnDict["name_with_type"] as? String ?? ""
        let model = WardModel(nameWithType: nameWithType)
        self.init(model: model)
    }
}
