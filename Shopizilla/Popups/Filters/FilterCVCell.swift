//
//  FilterCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 19/04/2022.
//

import UIKit

class FilterCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "FilterCVCell"
    
    let containerView = UIView()
    let titleLbl = UILabel()
    
    var isSelect: Bool = false {
        didSet {
            containerView.layer.borderColor = isSelect ? UIColor.black.cgColor : UIColor.lightGray.cgColor
            titleLbl.textColor = isSelect ? .black : .lightGray
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

extension FilterCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 22.0
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        titleLbl.textColor = .lightGray
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
