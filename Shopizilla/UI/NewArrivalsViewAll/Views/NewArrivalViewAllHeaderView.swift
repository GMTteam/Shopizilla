//
//  NewArrivalViewAllHeaderView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/06/2022.
//

import UIKit

class NewArrivalViewAllHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    static let id = "NewArrivalViewAllHeaderView"
    
    let titleView = NewArrivalViewAllTitleView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension NewArrivalViewAllHeaderView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        
        //TODO: - TitleView
        addSubview(titleView)
        
        titleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
