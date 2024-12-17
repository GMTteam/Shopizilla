//
//  RateProductDesView.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

class RateProductDesView: UIView {
    
    //MARK: - Properties
    let textView = RateDesTV()
    let numLbl = UILabel()
    
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

extension RateProductDesView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        heightAnchor.constraint(equalToConstant: (screenWidth-40)*0.7).isActive = true
        
        //TODO: - TextView
        textView.font = UIFont(name: FontName.ppRegular, size: 16.0)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15.0
        textView.textColor = .placeholderText
        textView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .systemGroupedBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        //TODO: - NumLbl
        numLbl.font = UIFont(name: FontName.ppMedium, size: 16.0)
        numLbl.textColor = .black
        numLbl.textAlignment = .right
        numLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numLbl)
        
        numLbl.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -10.0).isActive = true
        numLbl.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10.0).isActive = true
    }
}
