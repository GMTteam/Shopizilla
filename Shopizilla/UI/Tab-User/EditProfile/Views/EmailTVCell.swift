//
//  EmailTVCell.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 20/12/2021.
//

import UIKit

class EmailTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "EmailTVCell"
    
    let containerView = UIView()
    let emailLbl = UILabel()
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configures

extension EmailTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - ContainerView
        let height: CGFloat = 60.0
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = height/2
        containerView.layer.borderWidth = 1.0
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EmailLbl
        emailLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        emailLbl.textColor = .gray
        containerView.addSubview(emailLbl)
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            emailLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emailLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.0),
            emailLbl.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -15.0),
        ])
    }
}
