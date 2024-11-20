//
//  SearchScrollView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchScrollView: UIScrollView {
    
    //MARK: - Properties
    let containerView = SearchContainerView()
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

extension SearchScrollView {
    
    func setupViews(_ vc: SearchVC, dl: UIScrollViewDelegate) {
        setupScrollViews(dl: dl, ref: nil)
        vc.view.addSubview(self)
        
        //TODO: - NSLayoutConstraint
        setupConstraint(superView: vc.view, subview: vc.separatorView)
        
        //TODO: - ContainerView
        addSubview(containerView)
        
        //TODO: - NSLayoutConstraint
        cvHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightConstraint.priority = .defaultLow
        cvHeightConstraint.isActive = true
        
        containerView.setupConstraint(superView: self)
        containerView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 1.0).isActive = true
    }
}
