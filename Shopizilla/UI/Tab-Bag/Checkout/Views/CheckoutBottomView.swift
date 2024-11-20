//
//  CheckoutBottomView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 01/05/2022.
//

import UIKit

class CheckoutBottomView: UIView {
    
    //MARK: - Properties
    let subtotalView = UIView()
    let subtotalTitleLbl = UILabel()
    let oldSubtotalLbl = UILabel()
    let newSubtotalLbl = UILabel()
    
    let shippingFeeTitleLbl = UILabel()
    let shippingFeeLbl = UILabel()
    
    let separatorView = UIView()
    
    let totalView = UIView()
    let totalTitleLbl = UILabel()
    let totalLbl = UILabel()
    
    let orderBtn = ButtonAnimation()
    
    var heightConstraint: NSLayoutConstraint!
    
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

extension CheckoutBottomView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.3
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        //TODO: - SubtotalView
        subtotalView.clipsToBounds = true
        subtotalView.backgroundColor = .white
        subtotalView.translatesAutoresizingMaskIntoConstraints = false
        subtotalView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        subtotalView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        //TODO: - SubtotalTitleLbl
        let subF = UIFont(name: FontName.ppBold, size: 16.0)
        subtotalTitleLbl.font = subF
        subtotalTitleLbl.text = "Subtotal".localized()
        subtotalTitleLbl.textColor = .gray
        
        //TODO: - ShippingFeeTitleLbl
        shippingFeeTitleLbl.font = subF
        shippingFeeTitleLbl.text = "Shipping Fee".localized()
        shippingFeeTitleLbl.textColor = .gray
        
        //TODO: - UIStackView
        let subtotalTitleSV = createStackView(spacing: 8.0, distribution: .fill, axis: .vertical, alignment: .leading)
        subtotalTitleSV.addArrangedSubview(subtotalTitleLbl)
        subtotalTitleSV.addArrangedSubview(shippingFeeTitleLbl)
        subtotalView.addSubview(subtotalTitleSV)
        
        //TODO: - SubtotalLbl
        oldSubtotalLbl.font = subF
        oldSubtotalLbl.textColor = .gray
        oldSubtotalLbl.textAlignment = .right
        
        //TODO: - NewSubtotalLbl
        newSubtotalLbl.font = subF
        newSubtotalLbl.textColor = .gray
        newSubtotalLbl.textAlignment = .right
        
        //TODO: - UIStackView
        let subtotalSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        subtotalSV.addArrangedSubview(oldSubtotalLbl)
        subtotalSV.addArrangedSubview(newSubtotalLbl)
        
        //TODO: - ShippingFeeLbl
        shippingFeeLbl.font = subF
        shippingFeeLbl.textColor = .gray
        shippingFeeLbl.textAlignment = .right
        
        //TODO: - UIStackView
        let feeSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .trailing)
        feeSV.addArrangedSubview(subtotalSV)
        feeSV.addArrangedSubview(shippingFeeLbl)
        subtotalView.addSubview(feeSV)
        
        //TODO: - TotalView
        totalView.clipsToBounds = true
        totalView.backgroundColor = .white
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        totalView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        //TODO: - TotalTitleLbl
        totalTitleLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        totalTitleLbl.text = "Total Payment".localized()
        totalTitleLbl.textColor = .black
        totalTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        totalView.addSubview(totalTitleLbl)
        
        //TODO: - TotalLbl
        totalLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        totalLbl.textColor = .black
        totalLbl.textAlignment = .right
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        totalView.addSubview(totalLbl)
        
        //TODO: - OrderBtn
        orderBtn.clipsToBounds = true
        orderBtn.layer.cornerRadius = 25.0
        orderBtn.translatesAutoresizingMaskIntoConstraints = false
        orderBtn.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        orderBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(subtotalView)
        stackView.addArrangedSubview(totalView)
        stackView.addArrangedSubview(orderBtn)
        addSubview(stackView)
        
        //TODO: - SeparatorView
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = separatorColor
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        totalView.addSubview(separatorView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            
            subtotalTitleSV.centerYAnchor.constraint(equalTo: subtotalView.centerYAnchor),
            subtotalTitleSV.leadingAnchor.constraint(equalTo: subtotalView.leadingAnchor),
            
            feeSV.centerYAnchor.constraint(equalTo: subtotalView.centerYAnchor),
            feeSV.trailingAnchor.constraint(equalTo: subtotalView.trailingAnchor),
            
            totalTitleLbl.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            totalTitleLbl.leadingAnchor.constraint(equalTo: totalView.leadingAnchor),
            
            totalLbl.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            totalLbl.trailingAnchor.constraint(equalTo: totalView.trailingAnchor),
            
            separatorView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.centerXAnchor.constraint(equalTo: totalView.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: totalView.topAnchor),
        ])
        
        setupAlpha(false)
    }
    
    func setupTxtForBtn(_ txt: String) {
        setupTitleForBtn(orderBtn, txt: txt, bgColor: defaultColor, fgColor: .white)
    }
    
    func updateUI(_ vc: CheckoutVC, promoCode: PromoCode?, shippingFee: Double, coin: Double) {
        var percent = promoCode?.percent ?? 0.0
        var fee = shippingFee
        
        if let promoCode = promoCode, promoCode.type == PromoCode.PromoType.Freeship.rawValue {
            percent = 0.0
            fee = shippingFee * ((100 - promoCode.percent)/100)
        }
        
        let oldSubtotal = (appDL.shoppings.map({
            $0.total * ((100 - $0.saleOff)/100)
        }).reduce(0, +))
        
        let perc = (100 - percent)/100
        let newSubtotal = oldSubtotal * perc - (coin/1000)
        
        oldSubtotalLbl.text = ""
        oldSubtotalLbl.attributedText = nil
        
        if percent != 0.0 || coin != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppBold, size: 14.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldSubtotal.formattedCurrency, attributes: att)
            
            oldSubtotalLbl.attributedText = attr
        }
        
        oldSubtotalLbl.isHidden = percent == 0.0 && coin == 0.0
        newSubtotalLbl.isHidden = false
        
        newSubtotalLbl.text = newSubtotal.formattedCurrency
        shippingFeeLbl.text = fee == 0 ? "Free".localized().capitalized : fee.formattedCurrency
        totalLbl.text = (newSubtotal + fee).formattedCurrency
    }
    
    func setupAlpha(_ isEnabled: Bool) {
        orderBtn.isUserInteractionEnabled = isEnabled
        orderBtn.alpha = isEnabled ? 1.0 : 0.3
    }
}
