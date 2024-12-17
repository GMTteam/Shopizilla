//
//  SignInContentView.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/04/2022.
//

import UIKit

class SignInContentView: UIView {
    
    //MARK: - Properties
    private let effectView = UIVisualEffectView()
    
    let topView = UIView()
    let avatarImageView = UIImageView()
    let nameLbl = UILabel()
    let emailLbl = UILabel()
    
    let passwordTF = EmailTF()
    let continueBtn = ButtonAnimation()
    let forgotBtn = ButtonAnimation()
    
    let eyeImageView = UIImageView()
    
    private var btnWidth: CGFloat {
        return (screenWidth*0.95)-40
    }
    
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

extension SignInContentView {
    
    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 16.0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EffectView
        effectView.effect = UIBlurEffect(style: .light)
        effectView.clipsToBounds = true
        effectView.alpha = 0.95
        effectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(effectView)
        
        //TODO: - TopView
        topView.clipsToBounds = true
        topView.backgroundColor = .clear
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        //TODO: - PasswordTF
        passwordTF.setupLeftRightViewTF("Password (>7 characters)".localized(), imgName: "icon-password", rightImgView: eyeImageView)
        passwordTF.returnKeyType = .done
        passwordTF.isSecureTextEntry = true
        passwordTF.addDoneBtn(target: self, selector: #selector(doneDidTap))
        
        //TODO: - ContinueBtn
        setupTitleForBtn(continueBtn, txt: "Continue".localized(), bgColor: defaultColor, fgColor: .white)
        setupBtn(continueBtn, tag: 1)
        
        //TODO: - ForgotBtn
        setupTitleForBtn(forgotBtn, txt: "Forgot your password?".localized(), bgColor: .clear, fgColor: .white)
        forgotBtn.clipsToBounds = true
        forgotBtn.tag = 2
        forgotBtn.contentHorizontalAlignment = .left
        forgotBtn.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 15.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(passwordTF)
        stackView.setCustomSpacing(20.0, after: passwordTF)
        stackView.addArrangedSubview(continueBtn)
        stackView.addArrangedSubview(forgotBtn)
        addSubview(stackView)
        
        //TODO: - AvatarImageView
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 30.0
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        nameLbl.textColor = .white
        
        //TODO: - EmailLbl
        emailLbl.font = UIFont(name: FontName.ppRegular, size: 16.0)
        emailLbl.textColor = .white
        
        //TODO: - UIStackView
        let nameSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .leading)
        nameSV.addArrangedSubview(nameLbl)
        nameSV.addArrangedSubview(emailLbl)
        
        //TODO: - UIStackView
        let avaSV = createStackView(spacing: 15.0, distribution: .fill, axis: .horizontal, alignment: .center)
        avaSV.addArrangedSubview(avatarImageView)
        avaSV.addArrangedSubview(nameSV)
        topView.addSubview(avaSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            effectView.topAnchor.constraint(equalTo: topAnchor),
            effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            effectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),
            
            avaSV.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            avaSV.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            avaSV.trailingAnchor.constraint(lessThanOrEqualTo: topView.trailingAnchor),
        ])
    }
    
    private func setupBtn(_ btn: ButtonAnimation, tag: Int) {
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25.0
        btn.tag = tag
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    @objc private func doneDidTap() {
        passwordTF.resignFirstResponder()
    }
}
