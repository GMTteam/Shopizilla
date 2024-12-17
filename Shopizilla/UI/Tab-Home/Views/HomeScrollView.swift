//
//  HomeScrollView.swift
//  Shopizilla
//
//  Created by Anh Tu on 13/04/2022.
//

import UIKit

class HomeScrollView: UIScrollView {
    
    //MARK: - Properties
    let containerView = HomeContainerView()
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

extension HomeScrollView {
    
    func setupViews(_ vc: HomeVC, dl: UIScrollViewDelegate, ref: UIRefreshControl) {
        setupScrollViews(dl: dl, ref: ref)
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
