//
//  InfiniteDataSource.swift
//  Shopizilla
//
//  Created by Anh Tu on 16/04/2022.
//

import UIKit

class InfiniteDataSource {
    
    static func section(from section: Int, numberOfSections: Int) -> Int {
        return section % numberOfSections
    }
    
    static func indexPath(from indexPath: IndexPath, numberOfSections: Int, numberOfItems: Int) -> IndexPath {
        return IndexPath(item: indexPath.item % numberOfItems, section: section(from: indexPath.section, numberOfSections: numberOfSections))
    }
    
    static func multiplier(estimatedItemSize: CGSize, enabled: Bool) -> Int {
        guard enabled else { return 1 }
        let kMin = min(estimatedItemSize.width, estimatedItemSize.height)
        let count = ceil(InfiniteLayout.minimumContentSize/kMin)
        return Int(count)
    }
    
    static func numberOfSections(numberOfSections: Int, multiplier: Int) -> Int {
        return numberOfSections > 1 ? numberOfSections * multiplier : numberOfSections
    }
    
    static func numberOfItemsInSection(numberOfItemsInSection: Int, numberOfSection: Int, multiplier: Int) -> Int {
        return numberOfSection > 1 ? numberOfItemsInSection : numberOfItemsInSection * multiplier
    }
}
