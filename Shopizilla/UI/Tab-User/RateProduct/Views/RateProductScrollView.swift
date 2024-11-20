//
//  RateProductScrollView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

class RateProductScrollView: UIScrollView {
    
    //MARK: - Properties
    let containerView = RateProductContainerView()
    var cvHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension RateProductScrollView {
    
    func setupViews(_ vc: RateProductVC, dl: UIScrollViewDelegate) {
        setupScrollViews(dl: dl, ref: nil)
        vc.view.addSubview(self)
        
        //TODO: - NSLayoutConstraint
        setupConstraint(superView: vc.view, subview: vc.separatorView)
        
        //TODO: - ContainerView
        addSubview(containerView)
        cvHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightConstraint.priority = .defaultLow
        cvHeightConstraint.isActive = true
        
        containerView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 1.0).isActive = true
        containerView.setupConstraint(superView: self)
    }
}
