//
//  YourNameTVCell.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

class YourNameTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "YourNameTVCell"
    
    let containerView = UIView()
    let textField = UITextField()
    
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

extension YourNameTVCell {
    
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
        
        //TODO: - TextField
        textField.font = UIFont(name: FontName.ppBold, size: 16.0)
        textField.returnKeyType = .done
        textField.textColor = .black
        textField.placeholder = "Full name".localized()
        containerView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.0),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.0),
        ])
    }
}
