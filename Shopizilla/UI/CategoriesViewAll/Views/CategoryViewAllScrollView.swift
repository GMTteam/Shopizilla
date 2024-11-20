//
//  CategoryViewAllScrollView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 20/04/2022.
//

import UIKit

class CategoryViewAllScrollView: UIScrollView {
    
    //MARK: - Properties
    let containerView = CategoryViewAllContainerView()
    var cvHeightConstraint: NSLayoutConstraint!
    var cvTopConstraint: NSLayoutConstraint!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension CategoryViewAllScrollView {
    
    func setupViews(_ vc: CategoryViewAllVC, dl: UIScrollViewDelegate) {
        setupScrollViews(dl: dl, ref: nil)
        vc.view.addSubview(self)
        
        //TODO: - NSLayoutConstraint
        setupConstraint(superView: vc.view, subview: vc.separatorView)
        
        //TODO: - ContainerView
        addSubview(containerView)
        
        cvHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightConstraint.priority = .defaultLow
        cvHeightConstraint.isActive = true
        
        cvTopConstraint = containerView.topAnchor.constraint(equalTo: topAnchor)
        cvTopConstraint.isActive = true
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 1.0)
        ])
    }
}
