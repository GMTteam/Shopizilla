//
//  ProductNaviView.swift
//  Shopizilla
//
//  Created by Anh Tu on 24/04/2022.
//

import UIKit

class ProductNaviView: UIView {
    
    //MARK: - Properties
    let backView = UIView()
    let backBtn = ButtonAnimation()
    
    let bagView = UIView()
    let bagBtn = ButtonAnimation()
    let badgeLbl = UILabel()
    
    let heartView = UIView()
    let heartBtn = ButtonAnimation()
    
    let shareView = UIView()
    let shareBtn = ButtonAnimation()
    
    let chatView = UIView()
    let chatBtn = ButtonAnimation()
    
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

extension ProductNaviView {
    
    private func setupViews() {
        backgroundColor = .clear
        
        let gr = CAGradientLayer()
        gr.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: statusH+44)
        gr.colors = [
            UIColor(hex: 0x000000, alpha: 0.3).cgColor,
            UIColor(hex: 0xFFFFFF, alpha: 0.0).cgColor,
        ]
        gr.locations = [0.0, 1.0]
        layer.addSublayer(gr)
        
        //TODO: - BackBtn
        setupBtn(backView, backBtn, imgName: "icon-backLeft")
        addSubview(backView)
        
        //TODO: - BagBtn
        setupBtn(bagView, bagBtn, imgName: "icon-bagCenter")
        
        //TODO: - HeartBtn
        setupBtn(heartView, heartBtn, imgName: "icon-heart")
        
        //TODO: - ShareView
        setupBtn(shareView, shareBtn, imgName: "icon-share")
        
        //TODO: - ChatView
        setupBtn(chatView, chatBtn, imgName: "icon-chat")
        
        let stackView = createStackView(spacing: 10.0, distribution: .fillEqually, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(chatView)
        stackView.addArrangedSubview(shareView)
        stackView.addArrangedSubview(heartView)
        stackView.addArrangedSubview(bagView)
        addSubview(stackView)
        
        //TODO: - BadgeLbl
        let badgeH: CGFloat = 12.0
        badgeLbl.font = UIFont(name: FontName.ppBold, size: 7.0)
        badgeLbl.textColor = .white
        badgeLbl.textAlignment = .center
        badgeLbl.backgroundColor = defaultColor
        badgeLbl.clipsToBounds = true
        badgeLbl.layer.cornerRadius = badgeH/2
        badgeLbl.isHidden = true
        badgeLbl.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(badgeLbl, aboveSubview: bagBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0),
            
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0),
            
            badgeLbl.widthAnchor.constraint(equalToConstant: badgeH),
            badgeLbl.heightAnchor.constraint(equalToConstant: badgeH),
            badgeLbl.topAnchor.constraint(equalTo: bagBtn.topAnchor, constant: 2.0),
            badgeLbl.trailingAnchor.constraint(equalTo: bagBtn.trailingAnchor, constant: -2.0),
        ])
        
        setupHiddenBtn()
        updateHeartBtn(false)
    }
    
    private func setupBtn(_ parentView: UIView, _ btn: ButtonAnimation, imgName: String) {
        parentView.clipsToBounds = true
        parentView.backgroundColor = .white
        parentView.layer.cornerRadius = 12.0
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        setupShadow(parentView, radius: 1.0, opacity: 0.1)
        
        btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = defaultColor
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 12.0
        parentView.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            parentView.widthAnchor.constraint(equalToConstant: 40.0),
            parentView.heightAnchor.constraint(equalToConstant: 40.0),
            
            btn.topAnchor.constraint(equalTo: parentView.topAnchor),
            btn.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
    
    func updateBadge(_ badge: Int) {
        badgeLbl.isHidden = badge == 0
        badgeLbl.text = "\(badge)"
    }
    
    func updateHeartBtn(_ isFavorite: Bool) {
        let headerImg = isFavorite ? "icon-heartFilled" : "icon-heart"
        heartBtn.setImage(UIImage(named: headerImg), for: .normal)
    }
    
    func setupHiddenBtn() {
        chatView.isHidden = appDL.currentUser == nil || User.isAdmin()
        heartView.isHidden = appDL.currentUser == nil
    }
}
