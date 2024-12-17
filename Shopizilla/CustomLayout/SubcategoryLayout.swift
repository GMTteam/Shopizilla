//
//  SubcategoryLayout.swift
//  Shopizilla
//
//  Created by Anh Tu on 17/04/2022.
//

import UIKit

class SubcategoryLayout: CustomLayout {
    
    override func calculateCellFrame() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let collectionViewWidth = collectionView.frame.size.width
        let collectionViewHeight = collectionView.frame.size.height
        contentSize.height = collectionViewHeight
        
        let leftPadding = contentPadding.horizontal
        let rightPadding = collectionViewWidth - leftPadding
        
        var xOffset = contentAlign == .left ? leftPadding : rightPadding
        
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.frame.size = delegate!.cellSize(indexPath, cv: collectionView)
                
                let cellSize = attr.frame.size
                
                if contentAlign == .left {
                    attr.frame.origin.x = xOffset
                    xOffset += (cellSize.width + (itemsCount-1 == item ? 0.0 : cellPadding))
                }
                
                if contentAlign == .right {}
                
                cache.append(attr)
                contentSize.width = xOffset
            }
        }
    }
}
