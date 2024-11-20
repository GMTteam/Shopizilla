//
//  ProductContainerView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/04/2022.
//

import UIKit

class ProductContainerView: UIView {
    
    //MARK: - Properties
    let coverView = ProductCoverImageView()
    let titleView = ProductTitleView()
    let sizeView = ProductSizeView()
    let colorView = ProductColorView()
    let desView = ProductDescriptionView()
    let reviewsView = ProductReviewsView()
    let relatedView = ProductRelatedView()
    
    var stackView: UIStackView!
    
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

extension ProductContainerView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(coverView)
        stackView.setCustomSpacing(20.0, after: coverView)
        stackView.addArrangedSubview(titleView)
        stackView.setCustomSpacing(10.0, after: titleView)
        stackView.addArrangedSubview(sizeView)
        stackView.addArrangedSubview(colorView)
        stackView.addArrangedSubview(desView)
        stackView.addArrangedSubview(reviewsView)
        stackView.addArrangedSubview(relatedView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        stackView.setupConstraint(superView: self, bottomC: -30.0)
    }
    
    func updateHeight(_ vc: UIViewController) {
        isHidden = false
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            vc.view.layoutIfNeeded()
        }
    }
}
