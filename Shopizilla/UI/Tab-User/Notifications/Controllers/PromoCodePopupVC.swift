//
//  PromoCodePopupVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 17/06/2022.
//

import UIKit

protocol PromoCodePopupVCDelegate: AnyObject {
    func copyPromoCode(_ vc: PromoCodePopupVC, promoCodeUID: String)
}

class PromoCodePopupVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: PromoCodePopupVCDelegate?
    
    private let containerView = UIView()
    
    private let popupView = UIView()
    
    private let bgImageView = UIImageView()
    private let iconImageView = UIImageView()
    
    private let titleView = UIView()
    private let titleLbl = UILabel()
    
    private let percentView = UIView()
    private let percentLbl = UILabel()
    
    private let contentView = UIView()
    private let contentTitleLbl = UILabel()
    private let contentTimeLbl = UILabel()
    
    private let copyBtn = ButtonAnimation()
    
    var promoCodeUID = ""
    private var promoCode: PromoCode?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPromoCode()
    }
}

//MARK: - Setups

extension PromoCodePopupVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        //TODO: - PopupView
        let popW: CGFloat = screenWidth*0.8
        let popH: CGFloat = popW * (550/500)
        let popX: CGFloat = (screenWidth-popW)/2
        let popY: CGFloat = (screenHeight-popH)/2
        
        popupView.frame = CGRect(x: popX, y: popY, width: popW, height: popH)
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 16.0
        popupView.backgroundColor = .white
        popupView.isHidden = true
        view.addSubview(popupView)
        
        //TODO: - BGImageView
        bgImageView.frame = CGRect(x: 0.0, y: 0.0, width: popW, height: popH)
        bgImageView.clipsToBounds = true
        bgImageView.layer.cornerRadius = 16.0
        popupView.addSubview(bgImageView)
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        popupView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleView
        titleView.clipsToBounds = true
        titleView.backgroundColor = .clear
        popupView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        let fontS: CGFloat = 20.0
        titleLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.contentScaleFactor = 0.9
        titleView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PercentView
        percentView.clipsToBounds = true
        percentView.backgroundColor = .clear
        popupView.addSubview(percentView)
        percentView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PercentLbl
        percentLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: fontS*1.3)
        percentLbl.textColor = .white
        percentLbl.textAlignment = .center
        percentLbl.adjustsFontSizeToFitWidth = true
        percentLbl.contentScaleFactor = 0.9
        percentView.addSubview(percentLbl)
        percentLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContentView
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        popupView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContentTitleLbl
        let contentF: CGFloat = 30.0
        contentTitleLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: contentF)
        contentTitleLbl.textAlignment = .center
        contentTitleLbl.textColor = .black
        contentTitleLbl.adjustsFontSizeToFitWidth = true
        contentTitleLbl.contentScaleFactor = 0.9
        contentTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentTitleLbl.widthAnchor.constraint(equalToConstant: popW).isActive = true
        
        //TODO: - ContentTimeLbl
        contentTimeLbl.font = UIFont(name: FontName.arialRoundedMTBold, size: contentF*0.5)
        contentTimeLbl.textAlignment = .center
        contentTimeLbl.textColor = .gray
        contentTimeLbl.adjustsFontSizeToFitWidth = true
        contentTimeLbl.contentScaleFactor = 0.9
        contentTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        contentTimeLbl.widthAnchor.constraint(equalToConstant: popW).isActive = true
        
        //TODO: - PercentLbl
        let copyAttr = createMutableAttributedString(fgColor: .white, txt: "Copy Promo Code".localized())
        copyBtn.setAttributedTitle(copyAttr, for: .normal)
        copyBtn.clipsToBounds = true
        copyBtn.backgroundColor = .black
        copyBtn.layer.cornerRadius = 10
        copyBtn.tag = 1
        copyBtn.delegate = self
        copyBtn.translatesAutoresizingMaskIntoConstraints = false
        copyBtn.widthAnchor.constraint(equalToConstant: popW*0.7).isActive = true
        copyBtn.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        //TODO: - UIStackView
        let contentSV = createStackView(spacing: 2.0, distribution: .fill, axis: .vertical, alignment: .center)
        contentSV.addArrangedSubview(contentTitleLbl)
        contentSV.addArrangedSubview(contentTimeLbl)
        
        //TODO: - UIStackView
        let copySV = createStackView(spacing: 15.0, distribution: .fill, axis: .vertical, alignment: .center)
        copySV.addArrangedSubview(contentSV)
        copySV.addArrangedSubview(copyBtn)
        contentView.addSubview(copySV)
        
        //TODO: - NSLayoutConstraint
        let iconWidth = popW * (300/500)
        let iconHeight = iconWidth * (126.9/300)
        let iconBottom = popH * (289/550)
        
        let titleW = iconWidth * (297.5/520)
        let titleH = titleW * (195/297.5)
        
        let percentW = iconWidth * (191.5/520)
        let percentH = percentW * (195/191.5)
        let perTrail = iconWidth * (1 - (500/525))
        
        let contentW: CGFloat = popW
        let contentH: CGFloat = popH * (220/550)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -iconBottom),
            iconImageView.heightAnchor.constraint(equalToConstant: iconHeight),
            iconImageView.widthAnchor.constraint(equalToConstant: iconWidth),
            
            titleView.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            titleView.widthAnchor.constraint(equalToConstant: titleW),
            titleView.heightAnchor.constraint(equalToConstant: titleH),

            percentView.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            percentView.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: -perTrail),
            percentView.widthAnchor.constraint(equalToConstant: percentW),
            percentView.heightAnchor.constraint(equalToConstant: percentH),

            titleLbl.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(greaterThanOrEqualTo: titleView.leadingAnchor, constant: 5.0),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: titleView.trailingAnchor, constant: -5.0),

            percentLbl.centerXAnchor.constraint(equalTo: percentView.centerXAnchor),
            percentLbl.centerYAnchor.constraint(equalTo: percentView.centerYAnchor),
            percentLbl.leadingAnchor.constraint(greaterThanOrEqualTo: percentView.leadingAnchor, constant: 5.0),
            percentLbl.trailingAnchor.constraint(lessThanOrEqualTo: percentView.trailingAnchor, constant: -5.0),
            
            contentView.widthAnchor.constraint(equalToConstant: contentW),
            contentView.heightAnchor.constraint(equalToConstant: contentH),
            contentView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
            
            copySV.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            copySV.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        tap.numberOfTouchesRequired = 1
        containerView.addGestureRecognizer(tap)
    }
    
    private func setupAnim() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
        
        UIView.animateKeyframes(withDuration: 0.75, delay: 0.0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334) {
                self.popupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                self.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                self.popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
        } completion: { _ in }
    }
    
    @objc private func removeDidTap() {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.popupView.alpha = 0.0
            
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
    
    private func updateUI(_ promoCode: PromoCode) {
        setupAnim()
        
        let isFree = promoCode.type == PromoCode.PromoType.Freeship.rawValue
        let bgImageName = isFree ? "promo-bgFreeship" : "promo-bgDiscount"
        let iconImageName = isFree ? "promo-freeshipIcon" : "promo-discountIcon"
        
        bgImageView.image = UIImage(named: bgImageName)
        iconImageView.image = UIImage(named: iconImageName)
        
        titleLbl.text = isFree ? "FREESHIP".localized().uppercased() : "DISCOUNT".localized().uppercased()
        percentLbl.text = "\(promoCode.percent)%"
        
        contentTitleLbl.text = isFree ? "FREESHIP".localized().uppercased() : "DISCOUNT".localized().uppercased() + " \(promoCode.percent)%"
        
        if let startDate = longFormatter().date(from: promoCode.startDate),
           let endDate = longFormatter().date(from: promoCode.endDate) {
            let f = createDateFormatter()
            f.dateFormat = "MMM dd, yyyy"
            
            contentTimeLbl.text = "\(f.string(from: startDate)) - \(f.string(from: endDate))"
        }
    }
}

//MARK: - GetData

extension PromoCodePopupVC {
    
    private func getPromoCode() {
        guard promoCodeUID != "" else {
            return
        }
        
        let hud = HUD.hud(kWindow)
        
        PromoCode.fetchPromoCode(promoCodeUID) { promoCode in
            self.promoCode = promoCode
            hud.removeHUD {}
            self.popupView.isHidden = false
            
            if let promoCode = self.promoCode {
                self.updateUI(promoCode)
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension PromoCodePopupVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Copy
            delegate?.copyPromoCode(self, promoCodeUID: promoCodeUID)
        }
    }
}
