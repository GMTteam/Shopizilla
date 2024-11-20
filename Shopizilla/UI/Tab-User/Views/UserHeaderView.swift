//
//  UserHeaderView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 28/04/2022.
//

import UIKit

class UserHeaderView: UIView {
    
    //MARK: - Properties
    let profileImageView = UIImageView()
    let nameLbl = UILabel()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension UserHeaderView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        
        //TODO: - ProfileImageView
        let profW: CGFloat = screenWidth*0.3
        profileImageView.frame = CGRect(x: (screenWidth-profW)/2, y: 20.0, width: profW, height: profW)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profW/2
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)
        
        //TODO: - NameLbl
        nameLbl.frame = CGRect(x: 20.0, y: 20+profW+20, width: screenWidth-40, height: 40.0)
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 25.0)
        nameLbl.textAlignment = .center
        nameLbl.textColor = .black
        addSubview(nameLbl)
    }
    
    func updateUI(user: User?) {
        profileImageView.image = UIImage(named: "icon-profile")
        
        if let user = user {
            if let link = user.avatarLink {
                DownloadImage.shared.downloadImage(link: link) { image in
                    self.profileImageView.image = image
                }
            }
            
            nameLbl.text = user.fullName
            
        } else {
            nameLbl.text = nil
        }
    }
}
