//
//  ShopCVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 21/04/2022.
//

import UIKit

class ShopCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ShopCVCell"
    
    let containerView = UIView()
    let bannerImageView = UIImageView()
    let dimsView = UIView()
    let titleLbl = UILabel()
    
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
            updateAnimation(self, isEvent: isTouch, alpha: 0.8)
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

extension ShopCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20.0
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        //TODO: - BannerImageView
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 20.0
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bannerImageView)
        
        //TODO: - DimsView
        dimsView.clipsToBounds = true
        dimsView.layer.cornerRadius = 20.0
        dimsView.backgroundColor = .black.withAlphaComponent(0.7)
        dimsView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dimsView)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 30.0)
        titleLbl.textColor = .white
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bannerImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            dimsView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20.0),
        ])
    }
}
