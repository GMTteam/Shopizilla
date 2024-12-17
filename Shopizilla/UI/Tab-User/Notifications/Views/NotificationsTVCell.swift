//
//  NotificationsTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 14/06/2022.
//

import UIKit

class NotificationsTVCell: UITableViewCell {

    //MARK: - Properties
    static let id = "NotificationsTVCell"
    
    let containerView = UIView()
    let createdTimeLbl = UILabel()
    
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    let bodyLbl = UILabel()
    
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

extension NotificationsTVCell {
    
    func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CreatedTimeLbl
        createdTimeLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        createdTimeLbl.textColor = .gray
        createdTimeLbl.textAlignment = .right
        containerView.addSubview(createdTimeLbl)
        createdTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - IconImageView
        let iconW: CGFloat = 60.0
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconW/2
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        titleLbl.textColor = .black
        titleLbl.numberOfLines = 2
        
        //TODO: - BodyLbl
        bodyLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        bodyLbl.textColor = .gray
        bodyLbl.numberOfLines = 3
        
        //TODO: - UIStackView
        let nameSV = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .leading)
        nameSV.addArrangedSubview(titleLbl)
        nameSV.addArrangedSubview(bodyLbl)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(nameSV)
        containerView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            createdTimeLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0),
            createdTimeLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: createdTimeLbl.leadingAnchor, constant: -10.0),
        ])
    }
}
