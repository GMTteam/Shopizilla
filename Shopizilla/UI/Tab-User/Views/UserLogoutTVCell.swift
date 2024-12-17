//
//  UserLogoutTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/04/2022.
//

import UIKit

class UserLogoutTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "UserLogoutTVCell"
    
    private let logoutBtn = ButtonAnimation()
    
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

extension UserLogoutTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - LoginBtn
        setupTitleForBtn(logoutBtn, txt: "Logout".localized(), bgColor: defaultColor, fgColor: .white)
        logoutBtn.clipsToBounds = true
        logoutBtn.layer.cornerRadius = 25.0
        logoutBtn.delegate = self
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoutBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            logoutBtn.widthAnchor.constraint(equalToConstant: screenWidth-40),
            logoutBtn.heightAnchor.constraint(equalToConstant: 50),
            logoutBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension UserLogoutTVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        User.signOut {}
    }
}
