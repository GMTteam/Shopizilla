//
//  RateProductStarView.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

class RateProductStarView: UIView {
    
    //MARK: - Properties
    let rateStackView = RateStackView()
    
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

extension RateProductStarView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        //TODO: - RateStackView
        rateStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rateStackView)
        
        rateStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rateStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
