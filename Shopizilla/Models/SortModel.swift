//
//  SortModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 22/06/2022.
//

import Foundation

class SortModel {
    
    let title: String
    let index: Int
    
    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
    
    static func shared() -> [SortModel] {
        return [
            SortModel(title: "Sort A to Z".localized(), index: 0),
            SortModel(title: "Sort Z to A".localized(), index: 1),
            SortModel(title: "Price: Low to High".localized(), index: 2),
            SortModel(title: "Price: High to Low".localized(), index: 3),
            SortModel(title: "Random".localized(), index: 4)
        ]
    }
}
