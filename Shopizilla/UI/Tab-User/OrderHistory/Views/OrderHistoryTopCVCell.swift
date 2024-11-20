//
//  OrderHistoryTopCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 03/05/2022.
//

import UIKit

class OrderHistoryTopCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "OrderHistoryTopCVCell"
    
    let containerView = UIView()
    let titleLbl = UILabel()
    let redView = UIView()
    
    var isSelect: Bool = false {
        didSet {
            containerView.backgroundColor = isSelect ? defaultColor : .white
            titleLbl.textColor = isSelect ? .white : defaultColor
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

extension OrderHistoryTopCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 16.0)
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLbl)
        
        //TODO: - RedView
        redView.isHidden = true
        redView.clipsToBounds = true
        redView.backgroundColor = UIColor(hex: 0xF33D30)
        redView.layer.cornerRadius = 4.0
        redView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(redView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 40.0),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            redView.widthAnchor.constraint(equalToConstant: 8.0),
            redView.heightAnchor.constraint(equalToConstant: 8.0),
            redView.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            redView.topAnchor.constraint(equalTo: titleLbl.topAnchor),
        ])
    }
}
