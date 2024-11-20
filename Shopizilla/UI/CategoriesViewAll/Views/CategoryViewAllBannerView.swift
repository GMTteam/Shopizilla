//
//  CategoryViewAllBannerView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/04/2022.
//

import UIKit

class CategoryViewAllBannerView: UIView {
    
    //MARK: - Properties
    let bannerImageView = UIImageView()
    
    var bannerHeight: CGFloat = (screenWidth-40)*0.5
    var bannerHConstraint: NSLayoutConstraint!
    
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

extension CategoryViewAllBannerView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        bannerHConstraint = heightAnchor.constraint(equalToConstant: bannerHeight)
        bannerHConstraint.isActive = true
        
        //TODO: - CoverImageView
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 20.0
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bannerImageView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
