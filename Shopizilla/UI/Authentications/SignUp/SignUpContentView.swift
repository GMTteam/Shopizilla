//
//  SignUpContentView.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/04/2022.
//

import UIKit

class SignUpContentView: UIView {
    
    //MARK: - Properties
    private let effectView = UIVisualEffectView()
    
    let titleLbl = UILabel()
    
    let nameTF = EmailTF()
    let passwordTF = EmailTF()
    
    let termsLbl = UILabel()
    let continueBtn = ButtonAnimation()
    
    let eyeImageView = UIImageView()
    
    let termsOfService = "Terms of Service".localized()
    
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

extension SignUpContentView {
    
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
        
        //TODO: - TitleLbl
        titleLbl.numberOfLines = 0
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        
        //TODO: - NameTF
        nameTF.setupLeftViewTF("Name".localized(), imgName: "icon-fullName")
        nameTF.returnKeyType = .done
        nameTF.addDoneBtn(target: self, selector: #selector(nameDoneDidTap))
        
        //TODO: - PasswordTF
        passwordTF.setupLeftRightViewTF("Password (>7 characters)".localized(), imgName: "icon-password", rightImgView: eyeImageView)
        passwordTF.returnKeyType = .done
        passwordTF.isSecureTextEntry = true
        passwordTF.addDoneBtn(target: self, selector: #selector(passDoneDidTap))
        
        //TODO: - TermsLbl
        setupTermsLbl()
        termsLbl.numberOfLines = 0
        termsLbl.translatesAutoresizingMaskIntoConstraints = false
        termsLbl.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        
        //TODO: - ContinueBtn
        setupTitleForBtn(continueBtn, txt: "Agree And Continue".localized(), bgColor: defaultColor, fgColor: .white)
        setupBtn(continueBtn, tag: 1)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 15.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(nameTF)
        stackView.addArrangedSubview(passwordTF)
        stackView.addArrangedSubview(termsLbl)
        stackView.setCustomSpacing(30.0, after: termsLbl)
        stackView.addArrangedSubview(continueBtn)
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
    
    @objc private func nameDoneDidTap() {
        nameTF.resignFirstResponder()
    }
    
    @objc private func passDoneDidTap() {
        passwordTF.resignFirstResponder()
    }
    
    func setupTitleLbl(_ emailTxt: String) {
        let att1: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppRegular, size: 16.0)!,
            .foregroundColor: UIColor.white
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 16.0)!,
            .foregroundColor: UIColor.white
        ]
        
        let txt = "Looks like you don't have an account. Let's create a new account for ".localized()
        let attrStr1 = NSAttributedString(string: txt, attributes: att1)
        let attrStr2 = NSAttributedString(string: emailTxt, attributes: att2)
        
        let attr = NSMutableAttributedString()
        attr.append(attrStr1)
        attr.append(attrStr2)
        
        let stype = NSMutableParagraphStyle()
        stype.lineSpacing = 2.0
        
        let range = NSRange(location: 0, length: attr.length)
        attr.addAttribute(.paragraphStyle, value: stype, range: range)
        
        titleLbl.attributedText = attr
    }
    
    private func setupTermsLbl() {
        let txt1 = "By selecting Agree And Continue below, I agree to ".localized()
        
        let att1: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppRegular, size: 16.0)!,
            .foregroundColor: UIColor.white
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 16.0)!,
            .foregroundColor: UIColor.white
        ]
        
        let attrStr1 = NSAttributedString(string: txt1, attributes: att1)
        let attrStr2 = NSAttributedString(string: termsOfService, attributes: att2)
        
        let attr = NSMutableAttributedString()
        attr.append(attrStr1)
        attr.append(attrStr2)
        
        let stype = NSMutableParagraphStyle()
        stype.lineSpacing = 3.0
        
        let range = NSRange(location: 0, length: attr.length)
        attr.addAttribute(.paragraphStyle, value: stype, range: range)
        
        termsLbl.attributedText = attr
    }
}
