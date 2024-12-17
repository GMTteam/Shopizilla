//
//  UserTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/04/2022.
//

import UIKit

class UserTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "UserTVCell"
    
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    let redView = UIView()
    
    var model: ProfileModel! {
        didSet {
            iconImageView.image = model.image
            titleLbl.text = model.title
        }
    }
    
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

extension UserTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 17.0)
        titleLbl.textColor = .black
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLbl)
        contentView.addSubview(stackView)
        
        //TODO: - RedView
        redView.isHidden = true
        redView.clipsToBounds = true
        redView.backgroundColor = UIColor(hex: 0xF33D30)
        redView.layer.cornerRadius = 5.0
        redView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(redView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20.0),
            
            redView.widthAnchor.constraint(equalToConstant: 10.0),
            redView.heightAnchor.constraint(equalToConstant: 10.0),
            redView.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 5.0),
            redView.topAnchor.constraint(equalTo: titleLbl.topAnchor),
        ])
    }
}
