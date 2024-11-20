//
//  RateProductSubmitView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

class RateProductSubmitView: UIView {
    
    //MARK: - Properties
    let submitBtn = ButtonAnimation()
    
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

extension RateProductSubmitView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        //TODO: - SubmitBtn
        let attr = createMutableAttributedString(fgColor: .white, txt: "Submit Review".localized())
        submitBtn.setAttributedTitle(attr, for: .normal)
        submitBtn.clipsToBounds = true
        submitBtn.backgroundColor = defaultColor
        submitBtn.layer.cornerRadius = 25.0
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(submitBtn)
        
        submitBtn.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        submitBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        submitBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        submitBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
