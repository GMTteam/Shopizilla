//
//  HomeCategoriesTopCVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 17/04/2022.
//

import UIKit

class HomeCategoriesTopCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "HomeCategoriesTopCVCell"
    
    let containerView = UIView()
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    let subtitleLbl = UILabel()
    
    var isSelect: Bool = false {
        didSet {
            titleLbl.textColor = isSelect ? .white : .lightGray
            subtitleLbl.textColor = isSelect ? .white : .lightGray
            iconImageView.backgroundColor = UIColor(hex: isSelect ? 0x232323 : 0xEFEFEF)
            iconImageView.tintColor = isSelect ? .white : .lightGray
            containerView.backgroundColor = isSelect ? defaultColor : .black.withAlphaComponent(0.05)
        }
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
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

extension HomeCategoriesTopCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8.0
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 8.0
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 22.0)
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        
        //TODO: - SubtitleLbl
        subtitleLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        subtitleLbl.textColor = .black
        subtitleLbl.textAlignment = .left
        
        //TODO: - UIStackView
        let subSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .top)
        subSV.addArrangedSubview(titleLbl)
        subSV.addArrangedSubview(subtitleLbl)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(subSV)
        containerView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
