//
//  ChatLeftCVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 26/05/2022.
//

import UIKit

class ChatLeftCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ChatLeftCVCell"
    
    let containerView = UIView()
    let coverImageView = UIImageView()
    let messageLbl = UILabel()
    let timeLbl = UILabel()
    
    static let minHeight: CGFloat = 50.0
    static let maxHeight: CGFloat = (screenWidth-40)*0.8
    
    static let minWidth: CGFloat = 100.0
    static let maxWidth: CGFloat = (screenWidth-40)*0.6
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configure

extension ChatLeftCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 25.0
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        containerView.backgroundColor = UIColor(hex: 0xE9E9EB)
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        widthConstraint = containerView.widthAnchor.constraint(equalToConstant: ChatLeftCVCell.minWidth)
        widthConstraint.isActive = true
        
        heightConstraint = containerView.heightAnchor.constraint(equalToConstant: ChatLeftCVCell.minHeight)
        heightConstraint.isActive = true
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 25.0
        coverImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coverImageView)
        
        //TODO: - TimeLbl
        timeLbl.font = UIFont(name: FontName.ppRegular, size: 13.0)
        timeLbl.textColor = .darkGray
        timeLbl.textAlignment = .right
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLbl)
        
        //TODO: - MessageLbl
        messageLbl.font = UIFont(name: FontName.ppRegular, size: 16.0)
        messageLbl.textColor = .black
        messageLbl.numberOfLines = 0
        messageLbl.textAlignment = .left
        messageLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            timeLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4.5),
            timeLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.0),
            
            messageLbl.bottomAnchor.constraint(equalTo: timeLbl.topAnchor),
            messageLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.0),
            messageLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.0),
        ])
    }
}
