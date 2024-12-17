//
//  HomeContainerView.swift
//  Shopizilla
//
//  Created by Anh Tu on 13/04/2022.
//

import UIKit

class HomeContainerView: UIView {
    
    //MARK: - Properties
    let bannerView = HomeBannerView()
    let newArrivalView = HomeNewArrivalView()
    let featuredView = HomeFeaturedView()
    let categoriesView = HomeCategoriesView()
    
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

extension HomeContainerView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(bannerView)
        stackView.setCustomSpacing(0.0, after: bannerView)
        stackView.addArrangedSubview(newArrivalView)
        stackView.addArrangedSubview(featuredView)
        stackView.addArrangedSubview(categoriesView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        stackView.setupConstraint(superView: self, bottomC: -spBottom)
    }
}
