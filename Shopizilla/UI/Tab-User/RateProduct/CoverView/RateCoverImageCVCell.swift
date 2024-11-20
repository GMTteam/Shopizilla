//
//  RateCoverImageCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

protocol RateCoverImageCVCellDelegate: AnyObject {
    func deleteDidTap(cell: RateCoverImageCVCell)
}

class RateCoverImageCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "RateCoverImageCVCell"
    weak var delegate: RateCoverImageCVCellDelegate?
    
    let containerView = UIView()
    let coverImageView = UIImageView()
    let trashBtn = ButtonAnimation()
    
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

extension RateCoverImageCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        //TODO: - IconImageView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coverImageView)
        
        //TODO: - TrashBtn
        trashBtn.setImage(UIImage(named: "icon-trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        trashBtn.tintColor = .white
        trashBtn.backgroundColor = UIColor(hex: 0xF33D30)
        trashBtn.clipsToBounds = true
        trashBtn.delegate = self
        trashBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trashBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            trashBtn.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 35/80),
            trashBtn.heightAnchor.constraint(equalTo: trashBtn.widthAnchor, multiplier: 1.0),
            trashBtn.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            trashBtn.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
        ])
    }
    
    func setupCornerRadius(_ cornerRadius: CGFloat) {
        containerView.layer.cornerRadius = cornerRadius
        coverImageView.layer.cornerRadius = cornerRadius
        trashBtn.layer.cornerRadius = cornerRadius
        trashBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
}

//MARK: - ButtonAnimationDelegate

extension RateCoverImageCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.deleteDidTap(cell: self)
    }
}
