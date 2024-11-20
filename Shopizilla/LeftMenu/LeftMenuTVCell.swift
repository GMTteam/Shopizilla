//
//  LeftMenuTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 20/04/2022.
//

import UIKit

class LeftMenuTVCell: UITableViewCell {

    //MARK: - Properties
    static let id = "LeftMenuTVCell"
    
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    let arrowImageView = UIImageView()
    
    var isSelect: Bool = false {
        didSet {
            iconImageView.tintColor = isSelect ? defaultColor : .gray
            titleLbl.textColor = isSelect ? defaultColor : .gray
            arrowImageView.tintColor = isSelect ? defaultColor : .gray
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

extension LeftMenuTVCell {
    
    func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - IconImageView
        let iconW: CGFloat = 25.0
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .gray
        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 17.0)
        titleLbl.textColor = .gray
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLbl)
        contentView.addSubview(stackView)
        
        //TODO: - IconImageView
        let arrowW: CGFloat = 15.0
        arrowImageView.clipsToBounds = true
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = UIImage(named: "icon-rightArrow")?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = .gray
        arrowImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowImageView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: arrowW),
            arrowImageView.heightAnchor.constraint(equalToConstant: arrowW),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
        ])
    }
}
