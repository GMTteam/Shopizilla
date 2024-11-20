//
//  UIView+Ext.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/04/2022.
//

import UIKit

extension UIView {
    
    ///Top. Bottom. Leading. Trailing with constant = 0
    ///subview: Thiết lập topAnchor bên dưới subview (bottomAnchor)
    func setupConstraint(superView: UIView,
                         subview: UIView? = nil,
                         topC: CGFloat = 0.0,
                         leadingC: CGFloat = 0.0,
                         trailingC: CGFloat = 0.0,
                         bottomC: CGFloat = 0.0)
    {
        var topAnc = superView.topAnchor
        
        if let subview = subview {
            topAnc = subview.bottomAnchor
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnc, constant: topC),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: bottomC),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leadingC),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailingC),
        ])
    }
}
