//
//  RateProductContainerView.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

class RateProductContainerView: UIView {
    
    //MARK: - Properties
    let productView = RateProductView()
    let starView = RateProductStarView()
    let desView = RateProductDesView()
    let coverView = RateProductCoverView()
    let submitView = RateProductSubmitView()
    
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

extension RateProductContainerView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(productView)
        stackView.setCustomSpacing(0.0, after: productView)
        stackView.addArrangedSubview(starView)
        stackView.addArrangedSubview(desView)
        stackView.addArrangedSubview(coverView)
        stackView.addArrangedSubview(submitView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        stackView.setupConstraint(superView: self, bottomC: -30.0)
    }
}
