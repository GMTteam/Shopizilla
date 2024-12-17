//
//  OrderHistoryCenterView.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/05/2022.
//

import UIKit

class OrderHistoryCenterView: UIView {
    
    //MARK: - Properties
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    
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

extension OrderHistoryCenterView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        //TODO: - IconImageView
        let iconW: CGFloat = screenWidth*(appDL.isIPhoneX ? 0.5 : 0.4)
        iconImageView.clipsToBounds = true
        iconImageView.image = UIImage(named: "icon-addItem")
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppBold, size: 30.0)
        titleLbl.textColor = .black
        titleLbl.text = "No orders".localized()
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLbl)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
