//
//  BagBottomView.swift
//  Shopizilla
//
//  Created by Anh Tu on 27/04/2022.
//

import UIKit

class BagBottomView: UIView {
    
    //MARK: - Properties
    let totalView = UIView()
    
    let shippingFeeTitleLbl = UILabel()
    let shippingFeeLbl = UILabel()
    
    let totalTitleLbl = UILabel()
    let oldTotalLbl = UILabel()
    let newTotalLbl = UILabel()
    
    let orderBtn = ButtonAnimation()
    
    var heightConstraint: NSLayoutConstraint!
    var totalHeightConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
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

extension BagBottomView {
    
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
        
        //TODO: - TotalView
        totalView.clipsToBounds = true
        totalView.backgroundColor = .white
        totalView.layer.cornerRadius = 10.0
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        totalHeightConstraint = totalView.heightAnchor.constraint(equalToConstant: 60.0)
        totalHeightConstraint.isActive = true
        
        //TODO: - ShippingFeeTitleLbl
        shippingFeeTitleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        shippingFeeTitleLbl.text = "Shipping Fee".localized()
        shippingFeeTitleLbl.textColor = .gray
        shippingFeeTitleLbl.isHidden = true
        
        //TODO: - ShippingFeeLbl
        shippingFeeLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        shippingFeeLbl.textColor = .gray
        shippingFeeLbl.textAlignment = .right
        shippingFeeLbl.text = "FREE".localized().uppercased()
        shippingFeeLbl.isHidden = true
        
        //TODO: - TotalTitleLbl
        totalTitleLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        totalTitleLbl.text = "Total".localized()
        totalTitleLbl.textColor = .black
        
        //TODO: - TotalLbl
        oldTotalLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        oldTotalLbl.textColor = .gray
        oldTotalLbl.textAlignment = .right
        oldTotalLbl.isHidden = true
        
        //TODO: - DiscountLbl
        newTotalLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        newTotalLbl.textColor = .black
        newTotalLbl.textAlignment = .right
        newTotalLbl.isHidden = true
        
        //TODO: - UIStackView
        let titleSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .leading)
        titleSV.addArrangedSubview(shippingFeeTitleLbl)
        titleSV.addArrangedSubview(totalTitleLbl)
        totalView.addSubview(titleSV)
        
        //TODO: - UIStackView
        let totalSV = createStackView(spacing: 8.0, distribution: .fill, axis: .horizontal, alignment: .center)
        totalSV.addArrangedSubview(oldTotalLbl)
        totalSV.addArrangedSubview(newTotalLbl)
        
        //TODO: - UIStackView
        let subSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .trailing)
        subSV.addArrangedSubview(shippingFeeLbl)
        subSV.addArrangedSubview(totalSV)
        totalView.addSubview(subSV)
        
        //TODO: - OrderBtn
        orderBtn.clipsToBounds = true
        orderBtn.layer.cornerRadius = 25.0
        orderBtn.translatesAutoresizingMaskIntoConstraints = false
        orderBtn.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        orderBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(totalView)
        stackView.addArrangedSubview(orderBtn)
        addSubview(stackView)
        
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        bottomConstraint.isActive = true
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleSV.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            titleSV.leadingAnchor.constraint(equalTo: totalView.leadingAnchor),
            
            subSV.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            subSV.trailingAnchor.constraint(equalTo: totalView.trailingAnchor),
        ])
    }
    
    func setupTxtForBtn(_ txt: String) {
        setupTitleForBtn(orderBtn, txt: txt, bgColor: defaultColor, fgColor: .white)
    }
    
    func updateUI(_ promoCode: PromoCode?, coin: Double) {
        var percent = promoCode?.percent ?? 0.0
        
        shippingFeeTitleLbl.isHidden = true
        shippingFeeLbl.isHidden = true
        totalHeightConstraint.constant = 60.0
        
        if let promoCode = promoCode, promoCode.type == PromoCode.PromoType.Freeship.rawValue {
            percent = 0.0
            
            shippingFeeTitleLbl.isHidden = false
            shippingFeeLbl.isHidden = false
            totalHeightConstraint.constant = 80.0
        }
        
        //Lấy mảng total bên trong shoppings
        let oldTotal = (appDL.shoppings.map({
            //Kiểm tra xem có mặt hàng nào giảm giá ko
            $0.total * ((100 - $0.saleOff)/100)
        }).reduce(0, +))
        
        let perc = (100 - percent)/100
        let newTotal = (oldTotal*perc) - (coin/1000)
        
        oldTotalLbl.text = ""
        oldTotalLbl.attributedText = nil
        
        if percent != 0.0 || coin != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppBold, size: 17.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldTotal.formattedCurrency, attributes: att)
            
            oldTotalLbl.attributedText = attr
        }
        
        oldTotalLbl.isHidden = percent == 0.0 && coin == 0.0
        newTotalLbl.isHidden = false
        
        newTotalLbl.text = newTotal.formattedCurrency
    }
}
