//
//  PromoCodeTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 15/06/2022.
//

import UIKit

class PromoCodeTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "PromoCodeTVCell"
    
    let containerView = UIView()
    let bgImageView = UIImageView()
    let iconImageView = UIImageView()
    
    let titleView = UIView()
    let titleLbl = UILabel()
    let timeLbl = UILabel()
    
    let percentView = UIView()
    let percentLbl = UILabel()
    
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

extension PromoCodeTVCell {
    
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
        
        //TODO: - TitleView
        titleView.clipsToBounds = true
        titleView.backgroundColor = .clear
        containerView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        let fontS: CGFloat = 30.0
        titleLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.contentScaleFactor = 0.9
        
        //TODO: - TimeLbl
        timeLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS*0.4)
        timeLbl.textColor = .white
        timeLbl.textAlignment = .center
        timeLbl.numberOfLines = 2
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 2.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(timeLbl)
        titleView.addSubview(stackView)
        
        //TODO: - PercentView
        percentView.clipsToBounds = true
        percentView.backgroundColor = .clear
        containerView.addSubview(percentView)
        percentView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PercentLbl
        percentLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS*1.3)
        percentLbl.textColor = .white
        percentLbl.textAlignment = .center
        percentLbl.adjustsFontSizeToFitWidth = true
        percentLbl.contentScaleFactor = 0.9
        percentView.addSubview(percentLbl)
        percentLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CheckView
        let checkW: CGFloat = 20.0
        checkView.clipsToBounds = true
        checkView.backgroundColor = .white
        checkView.layer.cornerRadius = checkW/2
        checkView.layer.borderWidth = 1.0
        checkView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        containerView.addSubview(checkView)
        checkView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - InnerView
        let innerW: CGFloat = checkW*0.70
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = innerW/2
        innerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        checkView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        let cellHeight: CGFloat = (screenWidth-40) * (300/748)
        
        let iconHeight = cellHeight * (250/300)
        let iconWidth = iconHeight * (591/250)
        
        let titleW = iconWidth * (297.5/520)
        let titleH = titleW * (195/297.5)
        
        let percentW = iconWidth * (191.5/520)
        let percentH = percentW * (195/191.5)
        let perTrail = iconWidth * (1 - (500/525))
        
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
            
            titleView.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            titleView.widthAnchor.constraint(equalToConstant: titleW),
            titleView.heightAnchor.constraint(equalToConstant: titleH),
            
            percentView.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            percentView.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: -perTrail),
            percentView.widthAnchor.constraint(equalToConstant: percentW),
            percentView.heightAnchor.constraint(equalToConstant: percentH),
            
            stackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: titleView.leadingAnchor, constant: 5.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: titleView.trailingAnchor, constant: -5.0),
            
            percentLbl.centerXAnchor.constraint(equalTo: percentView.centerXAnchor),
            percentLbl.centerYAnchor.constraint(equalTo: percentView.centerYAnchor),
            percentLbl.leadingAnchor.constraint(greaterThanOrEqualTo: percentView.leadingAnchor, constant: 5.0),
            percentLbl.trailingAnchor.constraint(lessThanOrEqualTo: percentView.trailingAnchor, constant: -5.0),
            
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
