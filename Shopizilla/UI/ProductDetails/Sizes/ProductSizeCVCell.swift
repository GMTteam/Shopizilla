//
//  ProductSizeCVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 25/04/2022.
//

import UIKit

class ProductSizeCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ProductSizeCVCell"
    
    let containerView = UIView()
    let sizeLbl = UILabel()
    
    var isSelect: Bool = false {
        didSet {
            containerView.backgroundColor = isSelect ? .black : .white
            sizeLbl.textColor = isSelect ? .white : .black
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

extension ProductSizeCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        setupShadow(containerView, radius: 1.0, opacity: 0.1)
        
        //TODO: - SizeLbl
        sizeLbl.font = UIFont(name: FontName.ppSemiBold, size: 15.0)
        sizeLbl.textColor = .black
        sizeLbl.textAlignment = .center
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sizeLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sizeLbl.topAnchor.constraint(equalTo: containerView.topAnchor),
            sizeLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sizeLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sizeLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
