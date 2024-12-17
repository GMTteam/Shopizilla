//
//  CheckoutTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 01/05/2022.
//

import UIKit

class CheckoutTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "CheckoutTVCell"
    
    let feeLbl = UILabel()
    
    let checkView = UIView()
    let innerView = UIView()
    
    let nameLbl = UILabel()
    let iconImageView = UIImageView()
    
    let separatorView = UIView()
    
    //MARK: - Initializes
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

extension CheckoutTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - FeeLbl
        feeLbl.font = UIFont(name: FontName.ppMedium, size: 17.0)
        feeLbl.isHidden = true
        feeLbl.textColor = .black
        feeLbl.textAlignment = .right
        feeLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(feeLbl)
        
        //TODO: - CheckView
        let checkW: CGFloat = 25.0
        checkView.clipsToBounds = true
        checkView.layer.cornerRadius = checkW/2
        checkView.layer.borderWidth = 1.0
        checkView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.widthAnchor.constraint(equalToConstant: checkW).isActive = true
        checkView.heightAnchor.constraint(equalToConstant: checkW).isActive = true
        
        //TODO: - IconImageView
        iconImageView.isHidden = true
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 5.0
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        nameLbl.textColor = .black
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(checkView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(nameLbl)
        contentView.addSubview(stackView)
        
        //TODO: - InnerView
        let innerW: CGFloat = checkW*0.70
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = innerW/2
        innerView.backgroundColor = defaultColor
        innerView.translatesAutoresizingMaskIntoConstraints = false
        checkView.addSubview(innerView)
        
        //TODO: - SeparatorView
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = separatorColor
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            feeLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            feeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: feeLbl.leadingAnchor, constant: -10.0),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            innerView.widthAnchor.constraint(equalToConstant: innerW),
            innerView.heightAnchor.constraint(equalToConstant: innerW),
            innerView.centerXAnchor.constraint(equalTo: checkView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: checkView.centerYAnchor),
            
            separatorView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
