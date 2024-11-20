//
//  UICollectionView+Ext.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 13/04/2022.
//

import UIKit

internal extension UICollectionView {
    
    ///Cấu hình UICollectionView
    func setupCollectionView(_ bgColor: UIColor = .clear) {
        backgroundColor = bgColor
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    ///Spacing mặc định bằng 10
    func setupLayout(scrollDirection: ScrollDirection,
                     lineSpacing: CGFloat = 10.0,
                     itemSpacing: CGFloat = 10.0) {
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
    }
}
