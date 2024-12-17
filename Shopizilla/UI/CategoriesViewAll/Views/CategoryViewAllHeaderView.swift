//
//  CategoryViewAllHeaderView.swift
//  Shopizilla
//
//  Created by Anh Tu on 26/06/2022.
//

import UIKit

class CategoryViewAllHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    static let id = "CategoryViewAllHeaderView"
    
    let bannerView = CategoryViewAllBannerView()
    let titleView = NewArrivalViewAllTitleView()
    let subcatView = CategoryViewAllSubcatView()
    
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

extension CategoryViewAllHeaderView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        
        titleView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(bannerView)
        stackView.setCustomSpacing(10.0, after: bannerView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(subcatView)
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
