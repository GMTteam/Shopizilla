//
//  SelectRateCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

class SelectRateCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "SelectRateCVCell"
    
    let itemView = UIView()
    
    let arrowView = UIView()
    let arrowImageView = UIImageView()
    
    let coverView = UIView()
    let coverImageView = UIImageView()
    
    let nameLbl = UILabel()
    let separatorView = UIView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
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

extension SelectRateCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ItemView
        itemView.clipsToBounds = true
        itemView.backgroundColor = .white
        itemView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemView)
        
        //TODO: - ArrowView
        arrowView.clipsToBounds = true
        arrowView.layer.cornerRadius = 8.0
        arrowView.backgroundColor = .lightGray.withAlphaComponent(0.6)
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(arrowView)
        
        //TODO: - ArrowImageView
        arrowImageView.clipsToBounds = true
        arrowImageView.image = UIImage(named: "icon-rightArrow")
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.addSubview(arrowImageView)
        
        //TODO: - CoverView
        coverView.clipsToBounds = true
        coverView.backgroundColor = .white
        coverView.layer.cornerRadius = 15.0
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        setupShadow(coverView, radius: 1.0, opacity: 0.1)
        
        let coverW: CGFloat = screenWidth*0.2
        let coverH: CGFloat = coverW*imageHeightRatio
        coverView.widthAnchor.constraint(equalToConstant: coverW).isActive = true
        coverView.heightAnchor.constraint(equalToConstant: coverH).isActive = true
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 15.0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(coverImageView)
        
        //TODO: - ItemNameView
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 15.0)
        nameLbl.numberOfLines = 3
        nameLbl.textColor = .darkGray
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(coverView)
        stackView.addArrangedSubview(nameLbl)
        itemView.addSubview(stackView)
        
        //TODO: - SeparatorView
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = separatorColor
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            itemView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            itemView.heightAnchor.constraint(equalToConstant: OrderHistoryCVCell.centerH),
            itemView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowView.widthAnchor.constraint(equalToConstant: 50.0),
            arrowView.heightAnchor.constraint(equalToConstant: 50.0),
            arrowView.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: 20.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20.0),
            arrowImageView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: arrowView.leadingAnchor, constant: -10.0),
            
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
            
            separatorView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
