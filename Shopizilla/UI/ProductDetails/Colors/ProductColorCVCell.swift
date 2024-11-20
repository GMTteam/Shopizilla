//
//  ProductColorCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 25/04/2022.
//

import UIKit

class ProductColorCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ProductColorCVCell"
    
    let containerView = UIView()
    let innerView = UIView()
    
    let halfLeftBorderImageView = UIImageView()
    let halfRightBorderImageView = UIImageView()
    
    let halfLeftImageView = UIImageView()
    let halfRightImageView = UIImageView()
    
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

extension ProductColorCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        setupShadow(containerView, radius: 1.0, opacity: 0.1)
        
        //TODO: - InnerView
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = 5.0
        innerView.backgroundColor = .white
        innerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(innerView)
        
        setupShadow(innerView, radius: 1.0, opacity: 0.1)
        
        //TODO: - HalfLeftBorderImageView
        setupHalfBorderImageView(containerView, halfLeftBorderImageView, imgName: "icon-halfLeftBorder")
        
        //TODO: - HalfRightBorderImageView
        setupHalfBorderImageView(containerView, halfRightBorderImageView, imgName: "icon-halfRightBorder")
        
        //TODO: - HalfLeftImageView
        setupHalfBorderImageView(innerView, halfLeftImageView, imgName: "icon-halfLeft")
        
        //TODO: - HalfRightImageView
        setupHalfBorderImageView(innerView, halfRightImageView, imgName: "icon-halfRight")
        
        //TODO: - NSLayoutConstraint
        let sp: CGFloat = 4.0
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            innerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: sp),
            innerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sp),
            innerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sp),
            innerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -sp),
        ])
    }
    
    private func setupHalfBorderImageView(_ parentView: UIView, _ imgView: UIImageView, imgName: String) {
        imgView.isHidden = true
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(imgView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: parentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
    }
    
    func setHiddenHalf() {
        halfLeftBorderImageView.isHidden = true
        halfRightBorderImageView.isHidden = true

        halfLeftImageView.isHidden = true
        halfRightImageView.isHidden = true
        
        containerView.layer.borderColor = UIColor.clear.cgColor
        innerView.backgroundColor = .clear
    }
}
