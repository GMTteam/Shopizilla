//
//  WelContentView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit
import AuthenticationServices

class WelContentView: UIView {
    
    //MARK: - Properties
    private let effectView = UIVisualEffectView()
    
    let emailTF = EmailTF()
    let continueBtn = ButtonAnimation()
    let orLbl = UILabel()
    let facebookView = ViewAnimation()
    let googleView = ViewAnimation()
    let appleView = ViewAnimation()
    let guestBtn = ButtonAnimation()
    let forgotBtn = ButtonAnimation()
    
    let appleBtn = ASAuthorizationAppleIDButton(type: .continue, style: .white)
    
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

extension WelContentView {
    
    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 16.0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EffectView
        effectView.effect = UIBlurEffect(style: .light)
        effectView.clipsToBounds = true
        effectView.alpha = 0.95
        addSubview(effectView)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EmailTF
        emailTF.setupLeftViewTF("Email".localized(), imgName: "icon-email")
        emailTF.returnKeyType = .done
        emailTF.keyboardType = .emailAddress
        emailTF.autocapitalizationType = .none
        emailTF.addDoneBtn(target: self, selector: #selector(doneDidTap))
        
        //TODO: - ContinueBtn
        setupTitleForBtn(continueBtn, txt: "Continue".localized(), bgColor: defaultColor, fgColor: .white)
        setupBtn(continueBtn, tag: 0)
        
        //TODO: - OrLbl
        orLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        orLbl.text = "OR".localized()
        orLbl.textAlignment = .center
        orLbl.textColor = .white
        orLbl.translatesAutoresizingMaskIntoConstraints = false
        orLbl.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        
        //TODO: - FacebookView
        setupSocialView(facebookView, tag: 1, lblTxt: "Continue with Facebook".localized(), iconImg: UIImage(named: "icon-facebook"))
        
        //TODO: - GoogleView
        setupSocialView(googleView, tag: 2, lblTxt: "Continue with Google".localized(), iconImg: UIImage(named: "icon-google"))
        
        //TODO: - AppleView
        setupSocialView(appleView, tag: 3, lblTxt: "Continue with Apple".localized(), iconImg: UIImage(named: "icon-apple"))
        
        //TODO: - GuestBtn
        setupTitleForBtn(guestBtn, txt: "Browse as a guest".localized(), bgColor: defaultColor, fgColor: .white)
        setupBtn(guestBtn, tag: 1)
        
        //TODO: - ForgotBtn
        setupTitleForBtn(forgotBtn, txt: "Forgot your password?".localized(), bgColor: .clear, fgColor: .white)
        forgotBtn.clipsToBounds = true
        forgotBtn.tag = 2
        forgotBtn.contentHorizontalAlignment = .left
        forgotBtn.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 15.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(emailTF)
        stackView.addArrangedSubview(continueBtn)
        stackView.addArrangedSubview(orLbl)
        stackView.addArrangedSubview(facebookView)
        stackView.addArrangedSubview(googleView)
        stackView.addArrangedSubview(appleView)
        stackView.setCustomSpacing(20.0, after: appleView)
        stackView.addArrangedSubview(guestBtn)
        stackView.addArrangedSubview(forgotBtn)
        addSubview(stackView)
        
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
    
    private func setupSocialView(_ socialView: UIView, tag: Int, lblTxt: String = "", iconImg: UIImage? = nil) {
        socialView.clipsToBounds = true
        socialView.backgroundColor = .white
        socialView.layer.cornerRadius = 25.0
        socialView.tag = tag
        socialView.translatesAutoresizingMaskIntoConstraints = false
        socialView.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        socialView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        let iconImgView = UIImageView()
        iconImgView.clipsToBounds = true
        iconImgView.image = iconImg?.withRenderingMode(.alwaysTemplate)
        iconImgView.tintColor = defaultColor
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        socialView.addSubview(iconImgView)
        
        let lbl = UILabel()
        lbl.font = btnFont
        lbl.textColor = defaultColor
        lbl.text = lblTxt
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        socialView.addSubview(lbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            iconImgView.leadingAnchor.constraint(equalTo: socialView.leadingAnchor, constant: 20.0),
            iconImgView.centerYAnchor.constraint(equalTo: socialView.centerYAnchor),
            iconImgView.widthAnchor.constraint(equalToConstant: 20),
            iconImgView.heightAnchor.constraint(equalToConstant: 20),
            
            lbl.centerXAnchor.constraint(equalTo: socialView.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: socialView.centerYAnchor),
        ])
    }
    
    @objc private func doneDidTap() {
        emailTF.resignFirstResponder()
    }
}
