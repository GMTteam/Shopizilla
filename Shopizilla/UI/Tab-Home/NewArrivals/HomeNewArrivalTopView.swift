//
//  HomeNewArrivalTopView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/04/2022.
//

import UIKit

class HomeNewArrivalTopView: UIView {
    
    //MARK: - Properties
    let titleLbl = UILabel()
    let viewAllBtn = ButtonAnimation()
    
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

extension HomeNewArrivalTopView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 25.0)
        titleLbl.textColor = .black
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ViewAllBtn
        let viewAllAttr = createMutableAttributedString(fgColor: defaultColor, txt: "View All".localized())
        viewAllBtn.setAttributedTitle(viewAllAttr, for: .normal)
        addSubview(viewAllBtn)
        viewAllBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            
            viewAllBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            viewAllBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
