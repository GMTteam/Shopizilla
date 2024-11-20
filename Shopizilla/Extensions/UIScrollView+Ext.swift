//
//  UIScrollView+Ext.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/04/2022.
//

import UIKit

internal extension UIScrollView {
    
    func setupScrollViews(dl: UIScrollViewDelegate, ref: UIRefreshControl?) {
        clipsToBounds = true
        backgroundColor = .clear
        delegate = dl
        refreshControl = ref
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
}
