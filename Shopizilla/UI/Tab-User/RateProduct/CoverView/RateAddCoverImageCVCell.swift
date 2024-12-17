//
//  RateAddCoverImageCVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

class RateAddCoverImageCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "RateAddCoverImageCVCell"
    
    let containerView = UIView()
    let iconImageView = UIImageView()
    
    let shape = CAShapeLayer()
    
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

extension RateAddCoverImageCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15.0
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 15.0, height: 15.0)).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 5.0
        shape.lineDashPattern = [4, 3]
        containerView.layer.addSublayer(shape)
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.image = UIImage(named: "icon-addRateCoverImage")?.withRenderingMode(.alwaysTemplate)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 50.0),
            iconImageView.heightAnchor.constraint(equalToConstant: 50.0),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
