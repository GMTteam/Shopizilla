//
//  CreditCardVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 22/06/2022.
//

import UIKit
import Stripe

protocol CreditCardVCDelegate: AnyObject {
    func creditCardDoneDidTap(_ vc: CreditCardVC, cardParams: STPPaymentMethodCardParams, postalCode: String)
}

class CreditCardVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CreditCardVCDelegate?
    
    private let cardImageView = UIImageView()
    private lazy var cardTF: STPPaymentCardTextField = {
        return STPPaymentCardTextField()
    }()
    
    private let cancelBtn = ButtonAnimation()
    private let doneBtn = ButtonAnimation()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

//MARK: - Setups

extension CreditCardVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Credit Card".localized()
        
        //TODO: - CardImageView
        cardImageView.clipsToBounds = true
        cardImageView.image = UIImage(named: "stp_card_form_front")?.withRenderingMode(.alwaysTemplate)
        cardImageView.tintColor = .darkGray
        cardImageView.contentMode = .center
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        cardImageView.heightAnchor.constraint(equalToConstant: 50+(57*2)).isActive = true
        
        //TODO: - CardTF
        cardTF.font = UIFont(name: FontName.ppBold, size: 16.0)!
        cardTF.textColor = .darkGray
        cardTF.delegate = self
        cardTF.translatesAutoresizingMaskIntoConstraints = false
        cardTF.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        cardTF.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //TODO: - CancelBtn
        setupBtn(cancelBtn, txt: "Cancel".localized(), tag: 1)
        
        //TODO: - DoneBtn
        setupBtn(doneBtn, txt: "Order Place".localized(), tag: 2)
        
        enableDoneBtn()
        
        //TODO: - UIStackView
        let btnSV = createStackView(spacing: 20.0, distribution: .fillEqually, axis: .horizontal, alignment: .center)
        btnSV.addArrangedSubview(cancelBtn)
        btnSV.addArrangedSubview(doneBtn)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 30.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(cardImageView)
        stackView.addArrangedSubview(cardTF)
        stackView.addArrangedSubview(btnSV)
        view.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupBtn(_ btn: ButtonAnimation, txt: String, tag: Int) {
        let attr = createMutableAttributedString(fgColor: .white, txt: txt)
        btn.setAttributedTitle(attr, for: .normal)
        btn.backgroundColor = .black
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 50/2
        btn.delegate = self
        btn.tag = tag
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: (screenWidth-60)/2).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    private func enableDoneBtn() {
        doneBtn.isUserInteractionEnabled = cardTF.isValid
        doneBtn.alpha = cardTF.isValid ? 1.0 : 0.3
    }
}

//MARK: - STPPaymentCardTextFieldDelegate

extension CreditCardVC: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        enableDoneBtn()
    }
    
    func paymentCardTextFieldWillEndEditing(forReturn textField: STPPaymentCardTextField) {
        textField.resignFirstResponder()
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        let isAmex = STPCardValidator.brand(forNumber: textField.cardNumber ?? "") == STPCardBrand.amex
        
        let newImg: UIImage?
        let animTransition: UIView.AnimationOptions
        
        if isAmex {
            newImg = UIImage(named: "stp_card_form_amex_cvc")
            animTransition = .transitionCrossDissolve
            
        } else {
            newImg = UIImage(named: "stp_card_form_back")
            animTransition = .transitionFlipFromRight
        }
        
        UIView.transition(with: cardImageView, duration: 0.2, options: animTransition) {
            self.cardImageView.image = newImg?.withRenderingMode(.alwaysTemplate)
            self.cardImageView.tintColor = .darkGray
        }
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        let isAmex = STPCardValidator.brand(forNumber: textField.cardNumber ?? "") == STPCardBrand.amex
        let animTransition: UIView.AnimationOptions = isAmex ?
            .transitionCrossDissolve : .transitionFlipFromLeft
        
        UIView.transition(with: cardImageView, duration: 0.2, options: animTransition) {
            self.cardImageView.image = UIImage(named: "stp_card_form_front")?.withRenderingMode(.alwaysTemplate)
            self.cardImageView.tintColor = .darkGray
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension CreditCardVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Cancel
            dismiss(animated: true)
            
        } else if sender.tag == 2 { //Done
            delegate?.creditCardDoneDidTap(self, cardParams: cardTF.cardParams, postalCode: cardTF.postalCode ?? "")
        }
    }
}
