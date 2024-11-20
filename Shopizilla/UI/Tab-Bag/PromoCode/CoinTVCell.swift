//
//  CoinTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/06/2022.
//

import UIKit

class CoinTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "CoinTVCell"
    
    let containerView = UIView()
    let bgImageView = UIImageView()
    let iconImageView = UIImageView()
    
    let coinImageView = UIImageView()
    let coinLbl = UILabel()
    let subLbl = UILabel()
    
    let checkView = UIView()
    let innerView = UIView()
    
    var isSelect: Bool = false {
        didSet {
            innerView.backgroundColor = isSelect ? defaultColor : UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch, alpha: 0.5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isTouch { isTouch = true }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = superview {
            isTouch = frame.contains(touch.location(in: parent))
        }
    }
}

//MARK: - Configures

extension CoinTVCell {
    
    func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BGImageView
        bgImageView.clipsToBounds = true
        bgImageView.contentMode = .scaleAspectFill
        containerView.addSubview(bgImageView)
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoinImageView
        coinImageView.clipsToBounds = true
        coinImageView.contentMode = .scaleAspectFill
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        let fontS: CGFloat = 40.0
        coinLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS)
        coinLbl.textColor = .white
        coinLbl.adjustsFontSizeToFitWidth = true
        coinLbl.contentScaleFactor = 0.9
        
        //TODO: - TimeLbl
        subLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS*0.4)
        subLbl.textColor = .white
        subLbl.textAlignment = .center
        containerView.addSubview(subLbl)
        subLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(coinImageView)
        stackView.addArrangedSubview(coinLbl)
        containerView.addSubview(stackView)
        
        //TODO: - CheckView
        let checkW: CGFloat = 20.0
        checkView.isHidden = true
        checkView.clipsToBounds = true
        checkView.backgroundColor = .white
        checkView.layer.cornerRadius = checkW/2
        checkView.layer.borderWidth = 1.0
        checkView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        containerView.addSubview(checkView)
        checkView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - InnerView
        let innerW: CGFloat = checkW*0.70
        innerView.isHidden = true
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = innerW/2
        innerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        checkView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        let cellHeight: CGFloat = (screenWidth-40) * (300/748)
        
        let iconHeight = cellHeight * (250/300)
        let iconWidth = iconHeight * (504/250)
        
        let edge = (screenWidth - 40 - iconWidth)/2
        let halfEdge = edge/2
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            
            bgImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: iconHeight),
            iconImageView.widthAnchor.constraint(equalToConstant: iconWidth),
            
            coinImageView.widthAnchor.constraint(equalToConstant: iconHeight*0.36),
            coinImageView.heightAnchor.constraint(equalTo: coinImageView.widthAnchor, multiplier: 1.0),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            subLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subLbl.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: -10.0),
            
            checkView.widthAnchor.constraint(equalToConstant: checkW),
            checkView.heightAnchor.constraint(equalToConstant: checkW),
            checkView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: halfEdge-(checkW/2)),
            
            innerView.widthAnchor.constraint(equalToConstant: innerW),
            innerView.heightAnchor.constraint(equalToConstant: innerW),
            innerView.centerXAnchor.constraint(equalTo: checkView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: checkView.centerYAnchor),
        ])
    }
}
