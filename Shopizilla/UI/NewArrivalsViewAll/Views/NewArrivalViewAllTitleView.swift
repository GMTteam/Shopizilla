//
//  NewArrivalViewAllTitleView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 17/04/2022.
//

import UIKit

class NewArrivalViewAllTitleView: UIView {
    
    //MARK: - Properties
    let titleLbl = UILabel()
    let subtitleLbl = UILabel()
    let threeColumnsBtn = ButtonAnimation()
    let twoColumnsBtn = ButtonAnimation()
    
    var titleLeadingConstraint: NSLayoutConstraint!
    var buttonTrailingConstraint: NSLayoutConstraint!
    
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

extension NewArrivalViewAllTitleView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CenterTitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 22.0)
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        
        //TODO: - CenterSubtitleLbl
        subtitleLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        subtitleLbl.textColor = .lightGray
        subtitleLbl.textAlignment = .left
        
        //TODO: - UIStackView
        let titleSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .top)
        titleSV.addArrangedSubview(titleLbl)
        titleSV.addArrangedSubview(subtitleLbl)
        addSubview(titleSV)
        
        titleLeadingConstraint = titleSV.leadingAnchor.constraint(equalTo: leadingAnchor)
        titleLeadingConstraint.isActive = true
        
        //TODO: - ThreeColumnsBtn
        setupBtn(threeColumnsBtn, imgName: "icon-threeColumnsRight")
        
        //TODO: - TwoColumnsBtn
        setupBtn(twoColumnsBtn, imgName: "icon-twoColumnsRight")
        
        //TODO: - UIStackView
        let btnSV = createStackView(spacing: 0.0, distribution: .fillEqually, axis: .horizontal, alignment: .center)
        btnSV.addArrangedSubview(threeColumnsBtn)
        btnSV.addArrangedSubview(twoColumnsBtn)
        addSubview(btnSV)
        
        buttonTrailingConstraint = btnSV.trailingAnchor.constraint(equalTo: trailingAnchor)
        buttonTrailingConstraint.isActive = true
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            titleSV.centerYAnchor.constraint(equalTo: centerYAnchor),
            btnSV.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupBtn(_ btn: ButtonAnimation, imgName: String) {
        btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = defaultColor
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func updateTintColorForBtn(_ column: Int) {
        threeColumnsBtn.tintColor = column == 3 ? defaultColor : .lightGray
        twoColumnsBtn.tintColor = column == 2 ? defaultColor : .lightGray
    }
}

