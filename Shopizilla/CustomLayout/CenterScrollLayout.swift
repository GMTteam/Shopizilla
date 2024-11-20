//
//  CenterScrollLayout.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/04/2022.
//

import UIKit

class CenterScrollLayout: UICollectionViewFlowLayout {
    
    var currentPage = 0
    var previousOffset: CGFloat = 0
    
    var isCategories = false //Dành cho Mục Categories trên trang chủ
    var isProduct = false //Trang xem chi tiết Product. Mục CoverImage
    var isRelated = false //Trang xem chi tiết Product. Mục Related
    var isRecentlyViewed = false //Trang Search. Recently Viewed
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var itemsCount = cv.numberOfItems(inSection: 0)
        
        if isCategories || isRecentlyViewed {
            itemsCount = itemsCount >= 10 ? 10 : itemsCount
        }
        
        if previousOffset > cv.contentOffset.x && velocity.x < 0.0 {
            currentPage = max(currentPage-1, 0)
            
        } else if previousOffset < cv.contentOffset.x && velocity.x > 0.0 {
            if isCategories || isRelated {
                let i = Double(itemsCount) / 2
                let j = itemsCount / 2
                let k = i > Double(j) ? (j + 1) : j
                
                currentPage = min(currentPage+1, k-1)
                
            } else if isRecentlyViewed {
                let i = Double(itemsCount) / 3
                let j = itemsCount / 3
                let k = i > Double(j) ? (j + 1) : j
                
                currentPage = min(currentPage+1, k-1)
                
            } else {
                currentPage = min(currentPage+1, itemsCount-1)
            }
        }
        
        if isCategories {
            previousOffset = updateOffsetCategories()
            
        } else if isProduct {
            previousOffset = updateOffsetCover()
            
        } else if isRelated {
            previousOffset = updateOffsetRelated()
            
        } else if isRecentlyViewed {
            previousOffset = updateOffsetRecentlyViewed()
            
        } else {
            previousOffset = updateOffsetBanner()
        }
        
        return CGPoint(x: previousOffset, y: proposedContentOffset.y)
    }
    
    ///Banner
    private func updateOffsetBanner() -> CGFloat {
        let itemW = screenWidth-40
        let offset = (minimumLineSpacing*2 + itemW) * CGFloat(currentPage) - minimumLineSpacing*2
        return offset
    }
    
    ///Cover
    private func updateOffsetCover() -> CGFloat {
        let itemW = screenWidth-60
        let offset = (minimumLineSpacing + itemW) * CGFloat(currentPage) - minimumLineSpacing
        return offset
    }
    
    ///Related
    private func updateOffsetRelated() -> CGFloat {
        let itemW = (screenWidth-70) / 2.2
        let i = (minimumLineSpacing + itemW)*2
        let j = (screenWidth - i - 20)/2
        let offset = i * CGFloat(currentPage) - j
        return offset
    }
    
    ///Categories
    private func updateOffsetCategories() -> CGFloat {
        let itemW = (screenWidth-70) / 2.2
        let i = (minimumLineSpacing + itemW)*2
        let j = (screenWidth - i - 40)/2
        let offset = i * CGFloat(currentPage) - (20 + j)
        return offset
    }
    
    ///RecentlyViewed
    private func updateOffsetRecentlyViewed() -> CGFloat {
        let itemW = (screenWidth-70) / 3.2
        let i = (minimumLineSpacing + itemW)*3
        let offset = i * CGFloat(currentPage) - 20
        return offset
    }
}
