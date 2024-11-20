//
//  CategoryViewAllContainerView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 20/04/2022.
//

import UIKit

class CategoryViewAllContainerView: UIView {
    
    //MARK: - Properties
    let bannerView = CategoryViewAllBannerView()
    let titleView = NewArrivalViewAllTitleView()
    let subcatView = CategoryViewAllSubcatView()
    let productView = NewArrivalViewAllProductView()
    
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

extension CategoryViewAllContainerView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        titleView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        titleView.titleLeadingConstraint.constant = 20.0
        titleView.buttonTrailingConstraint.constant = -20.0
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(bannerView)
        stackView.setCustomSpacing(10.0, after: bannerView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(subcatView)
        stackView.addArrangedSubview(productView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        stackView.setupConstraint(superView: self, bottomC: -30.0)
    }
}
