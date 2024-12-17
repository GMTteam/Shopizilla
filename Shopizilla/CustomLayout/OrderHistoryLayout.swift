//
//  OrderHistoryLayout.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/05/2022.
//

import UIKit

class OrderHistoryLayout: CustomLayout {
    
    override func calculateCellFrame() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let collectionViewWidth = collectionView.frame.size.width
        contentSize.width = collectionViewWidth
        
        let leftPadding = contentPadding.horizontal
        let rightPadding = collectionViewWidth - leftPadding
        
        var xOffset = contentAlign == .left ? leftPadding : rightPadding
        var yOffset = contentPadding.vertical
        
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
                    attr.frame.origin.y = yOffset
                    
                    xOffset = leftPadding
                    yOffset += cellSize.height + cellPadding
                }
                
                if contentAlign == .right {}
                
                cache.append(attr)
                contentSize.height = yOffset + cellPadding
            }
        }
    }
}
