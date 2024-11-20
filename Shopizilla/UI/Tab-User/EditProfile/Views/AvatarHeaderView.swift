//
//  AvatarHeaderView.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

class AvatarHeaderView: UIView {
    
    //MARK: - Properties
    let profileImageView = UIImageView()
    let editBtn = ButtonAnimation()
    
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

extension AvatarHeaderView {
    
    private func setupViews() {
        backgroundColor = .clear
        clipsToBounds = true
        
        //TODO: - ProfileImageView
        let profW: CGFloat = screenWidth*0.3
        profileImageView.frame = CGRect(x: (screenWidth-profW)/2, y: 20.0, width: profW, height: profW)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profW/2
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)
        
        //TODO: - EditBtn
        let editW: CGFloat = 35.0
        let editX = profileImageView.frame.origin.x + profW - editW
        let editY = profileImageView.frame.origin.y + profW - editW - 8
        editBtn.frame = CGRect(x: editX, y: editY, width: editW, height: editW)
        editBtn.setImage(UIImage(named: "icon-camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        editBtn.backgroundColor = defaultColor
        editBtn.tintColor = .white
        editBtn.clipsToBounds = true
        editBtn.layer.cornerRadius = editW/2
        addSubview(editBtn)
    }
    
    func updateUI(user: User) {
        profileImageView.image = UIImage(named: "icon-profile")
        
        if let link = user.avatarLink {
            DownloadImage.shared.downloadImage(link: link) { image in
                self.profileImageView.image = image
            }
        }
    }
}
