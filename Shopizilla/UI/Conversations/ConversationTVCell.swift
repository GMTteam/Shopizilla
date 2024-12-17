//
//  ConversationTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 30/05/2022.
//

import UIKit

class ConversationTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "ConversationTVCell"
    
    let timeLbl = UILabel()
    let avatarImageView = UIImageView()
    let nameLbl = UILabel()
    let mesLbl = UILabel()
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
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

extension ConversationTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - TimeLbl
        timeLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        timeLbl.textColor = .gray
        timeLbl.textAlignment = .right
        contentView.addSubview(timeLbl)
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - AvatarImageView
        let avarW: CGFloat = 50.0
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avarW/2
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: avarW).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: avarW).isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        nameLbl.textColor = .black
        
        //TODO: - MesLbl
        mesLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        mesLbl.textColor = .gray
        
        //TODO: - UIStackView
        let nameSV = createStackView(spacing: 2.0, distribution: .fill, axis: .vertical, alignment: .leading)
        nameSV.addArrangedSubview(nameLbl)
        nameSV.addArrangedSubview(mesLbl)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 15.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(nameSV)
        contentView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            timeLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            timeLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: timeLbl.leadingAnchor, constant: -10.0),
        ])
    }
}
