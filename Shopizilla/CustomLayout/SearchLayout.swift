//
//  SearchLayout.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchLayout: CustomLayout {
    
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
                    if xOffset + cellSize.width + cellPadding > collectionViewWidth-20 {
                        xOffset = leftPadding
                        yOffset += cellSize.height + cellPadding
                    }
                    
                    attr.frame.origin.x = xOffset
                    attr.frame.origin.y = yOffset
                    xOffset += (cellSize.width + cellPadding)
                }
                
                if contentAlign == .right {}
                
                cache.append(attr)
                contentSize.height = yOffset + cellSize.height + cellPadding
            }
        }
    }
}
