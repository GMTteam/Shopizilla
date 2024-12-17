//
//  MyOrderSubCVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/05/2022.
//

import UIKit

protocol MyOrderSubCVCellDelegate: AnyObject {
    func rateDidTap(_ cell: MyOrderSubCVCell)
}

class MyOrderSubCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "MyOrderSubCVCell"
    weak var delegate: MyOrderSubCVCellDelegate?
    
    let subtotalView = UIView()
    let subtotalTitleLbl = UILabel()
    let oldSubtotalLbl = UILabel()
    let newSubtotalLbl = UILabel()
    
    let shippingFeeTitleLbl = UILabel()
    let shippingFeeLbl = UILabel()
    
    let totalView = UIView()
    let totalTitleLbl = UILabel()
    let totalLbl = UILabel()
    
    let rateBtn = ButtonAnimation()
    
    let rateView = UIView()
    let rateTitleLbl = UILabel()
    let rateSubLbl = UILabel()
    let starImageView = UIImageView()
    let tapRateImageView = UIImageView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configures

extension MyOrderSubCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - SubtotalView
        subtotalView.clipsToBounds = true
        subtotalView.backgroundColor = .white
        subtotalView.translatesAutoresizingMaskIntoConstraints = false
        subtotalView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        subtotalView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        //TODO: - BottomView
        totalView.clipsToBounds = true
        totalView.backgroundColor = .white
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        totalView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        //TODO: - RateView
        rateView.clipsToBounds = true
        rateView.layer.cornerRadius = 15.0
        rateView.backgroundColor = UIColor(hex: 0xFAFAFF)
        rateView.translatesAutoresizingMaskIntoConstraints = false
        rateView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        rateView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 8.0, distribution: .fill, axis: .vertical, alignment: .leading)
        stackView.addArrangedSubview(subtotalView)
        stackView.addArrangedSubview(totalView)
        stackView.addArrangedSubview(rateView)
        contentView.addSubview(stackView)
        
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
        
        //TODO: - OldSubtotalLbl
        oldSubtotalLbl.font = subF
        oldSubtotalLbl.textColor = .gray
        oldSubtotalLbl.textAlignment = .right
        
        //TODO: - NewSubtotalLbl
        newSubtotalLbl.font = subF
        newSubtotalLbl.textColor = .gray
        newSubtotalLbl.textAlignment = .right
        
        //TODO: - UIStackView
        let priceSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        priceSV.addArrangedSubview(oldSubtotalLbl)
        priceSV.addArrangedSubview(newSubtotalLbl)
        
        //TODO: - ShippingFeeLbl
        shippingFeeLbl.font = subF
        shippingFeeLbl.textColor = .gray
        shippingFeeLbl.textAlignment = .right
        
        //TODO: - UIStackView
        let feeSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .trailing)
        feeSV.addArrangedSubview(priceSV)
        feeSV.addArrangedSubview(shippingFeeLbl)
        subtotalView.addSubview(feeSV)
        
        //TODO: - TotalTitleLbl
        totalTitleLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        totalTitleLbl.text = "Total:".localized()
        totalTitleLbl.textColor = .black
        
        //TODO: - TotalLbl
        totalLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        totalLbl.textColor = .black
        
        //TODO: - UIStackView
        let totalSV = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .leading)
        totalSV.addArrangedSubview(totalTitleLbl)
        totalSV.addArrangedSubview(totalLbl)
        totalView.addSubview(totalSV)
        
        //TODO: - RateBtn
        let rateAttr = createMutableAttributedString(fgColor: .white, txt: "Rate".localized())
        rateBtn.setAttributedTitle(rateAttr, for: .normal)
        rateBtn.clipsToBounds = true
        rateBtn.layer.cornerRadius = 25.0
        rateBtn.backgroundColor = defaultColor
        rateBtn.delegate = self
        rateBtn.translatesAutoresizingMaskIntoConstraints = false
        totalView.addSubview(rateBtn)
        
        //TODO: - TapRateImageView
        tapRateImageView.clipsToBounds = true
        tapRateImageView.image = UIImage(named: "forget-tapRate")?.withRenderingMode(.alwaysTemplate)
        tapRateImageView.tintColor = .gray
        tapRateImageView.contentMode = .scaleAspectFill
        tapRateImageView.translatesAutoresizingMaskIntoConstraints = false
        tapRateImageView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        tapRateImageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        //TODO: - RateTitleLbl
        rateTitleLbl.font = UIFont(name: FontName.ppBold, size: 14.0)
        rateTitleLbl.text = "Don’t forget to rate".localized()
        rateTitleLbl.textColor = .darkGray
        rateTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        rateTitleLbl.widthAnchor.constraint(equalToConstant: screenWidth-40-70-40).isActive = true
        
        //TODO: - RateSubLbl=
        rateSubLbl.font = UIFont(name: FontName.ppRegular, size: 12.0)
        rateSubLbl.text = "Submit your review to get 25 points".localized()
        rateSubLbl.textColor = .gray
        rateSubLbl.numberOfLines = 2
        rateSubLbl.translatesAutoresizingMaskIntoConstraints = false
        rateSubLbl.widthAnchor.constraint(equalToConstant: screenWidth-40-70-40).isActive = true
        
        //TODO: - StarImageView
        starImageView.clipsToBounds = true
        starImageView.image = UIImage(named: "forget-star")?.withRenderingMode(.alwaysTemplate)
        starImageView.tintColor = .lightGray
        starImageView.contentMode = .scaleAspectFill
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: 15 * (275/40)).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        //TODO: - UIStackView
        let rateSV = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .leading)
        rateSV.addArrangedSubview(rateTitleLbl)
        rateSV.addArrangedSubview(rateSubLbl)
        rateSV.setCustomSpacing(10.0, after: rateSubLbl)
        rateSV.addArrangedSubview(starImageView)
        
        //TODO: - UIStackView
        let tapRateSV = createStackView(spacing: 20.0, distribution: .fill, axis: .horizontal, alignment: .center)
        tapRateSV.addArrangedSubview(tapRateImageView)
        tapRateSV.addArrangedSubview(rateSV)
        rateView.addSubview(tapRateSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            subtotalTitleSV.centerYAnchor.constraint(equalTo: subtotalView.centerYAnchor),
            subtotalTitleSV.leadingAnchor.constraint(equalTo: subtotalView.leadingAnchor),
            
            feeSV.centerYAnchor.constraint(equalTo: subtotalView.centerYAnchor),
            feeSV.trailingAnchor.constraint(equalTo: subtotalView.trailingAnchor),
            
            totalSV.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            totalSV.leadingAnchor.constraint(equalTo: totalView.leadingAnchor),
            
            rateBtn.widthAnchor.constraint(equalToConstant: (screenWidth-40)/2),
            rateBtn.heightAnchor.constraint(equalToConstant: 50.0),
            rateBtn.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            rateBtn.trailingAnchor.constraint(equalTo: totalView.trailingAnchor),
            
            tapRateSV.centerXAnchor.constraint(equalTo: rateView.centerXAnchor),
            tapRateSV.centerYAnchor.constraint(equalTo: rateView.centerYAnchor),
        ])
    }
    
    func updatePrice(_ shoppingStatus: ShoppingStatus) {
        let promotion = shoppingStatus.percentPromotion ?? 0.0
        let oldSubtotal = (shoppingStatus.shoppings.map({
            $0.total * ((100 - $0.saleOff)/100)
        }).reduce(0, +))
        
        let perc = (100 - promotion)/100
        let newSubtotal = oldSubtotal * perc - (shoppingStatus.coin/1000)
        
        oldSubtotalLbl.text = ""
        oldSubtotalLbl.attributedText = nil

        if promotion != 0.0 || shoppingStatus.coin != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppSemiBold, size: 14.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldSubtotal.formattedCurrency, attributes: att)

            oldSubtotalLbl.attributedText = attr
        }

        oldSubtotalLbl.isHidden = promotion == 0.0 && shoppingStatus.coin == 0.0
        newSubtotalLbl.text = newSubtotal.formattedCurrency
        
        let paidTxt = shoppingStatus.isPaid ? "(PAID)".localized() : ""
        totalLbl.text = (newSubtotal + shoppingStatus.shippingFee).formattedCurrency + " \(paidTxt)"
    }
}

//MARK: - ButtonAnimationDelegate

extension MyOrderSubCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.rateDidTap(self)
    }
}
