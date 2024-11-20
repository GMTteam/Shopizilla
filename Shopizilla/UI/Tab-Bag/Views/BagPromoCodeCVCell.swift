//
//  BagPromoCodeCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 30/04/2022.
//

import UIKit

protocol BagPromoCodeCVCellDelegate: AnyObject {
    func choosePromoCodeDidTap(_ cell: BagPromoCodeCVCell)
    func removePromoCodeDidTap(_ cell: BagPromoCodeCVCell)
}

class BagPromoCodeCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "BagPromoCodeCVCell"
    weak var delegate: BagPromoCodeCVCellDelegate?
    
    let promoCodeView = UIView()
    let removeBtn = ButtonAnimation()
    let applyBtn = ButtonAnimation()
    let promoCodeTF = PromoCodeTF()
    
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

extension BagPromoCodeCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - PromoCodeView
        promoCodeView.clipsToBounds = true
        promoCodeView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        promoCodeView.layer.cornerRadius = 10.0
        promoCodeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(promoCodeView)
        
        //TODO: - RemoveBtn
        let removeH: CGFloat = 40.0
        removeBtn.isHidden = true
        removeBtn.clipsToBounds = true
        removeBtn.setImage(UIImage(named: "icon-searchRemove"), for: .normal)
        removeBtn.tintColor = .lightGray
        removeBtn.layer.cornerRadius = removeH/2
        removeBtn.delegate = self
        removeBtn.tag = 1
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.widthAnchor.constraint(equalToConstant: removeH).isActive = true
        removeBtn.heightAnchor.constraint(equalToConstant: removeH).isActive = true
        
        //TODO: - ApplyBtn
        setTxtForBtn("Choose".localized())
        applyBtn.clipsToBounds = true
        applyBtn.backgroundColor = defaultColor
        applyBtn.layer.cornerRadius = 8.0
        applyBtn.delegate = self
        applyBtn.tag = 2
        applyBtn.translatesAutoresizingMaskIntoConstraints = false
        applyBtn.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        applyBtn.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        //TODO: - UIStackView
        let btnSV = createStackView(spacing: 0.0, distribution: .fill, axis: .horizontal, alignment: .center)
        btnSV.addArrangedSubview(removeBtn)
        btnSV.addArrangedSubview(applyBtn)
        promoCodeView.addSubview(btnSV)
        
        //TODO: - PromoCodeTF
        promoCodeTF.font = UIFont(name: FontName.ppRegular, size: 16.0)
        promoCodeTF.placeholder = "Promo Code".localized()
        promoCodeTF.clipsToBounds = true
        promoCodeTF.returnKeyType = .done
        promoCodeTF.autocapitalizationType = .allCharacters
        promoCodeTF.translatesAutoresizingMaskIntoConstraints = false
        promoCodeView.addSubview(promoCodeTF)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            promoCodeView.widthAnchor.constraint(equalToConstant: screenWidth-10),
            promoCodeView.heightAnchor.constraint(equalToConstant: 60.0),
            promoCodeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            promoCodeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            btnSV.centerYAnchor.constraint(equalTo: promoCodeView.centerYAnchor),
            btnSV.trailingAnchor.constraint(equalTo: promoCodeView.trailingAnchor, constant: -10.0),
            
            promoCodeTF.leadingAnchor.constraint(equalTo: promoCodeView.leadingAnchor),
            promoCodeTF.topAnchor.constraint(equalTo: promoCodeView.topAnchor),
            promoCodeTF.bottomAnchor.constraint(equalTo: promoCodeView.bottomAnchor),
            promoCodeTF.trailingAnchor.constraint(equalTo: btnSV.leadingAnchor, constant: -10.0),
        ])
    }
    
    func setTxtForBtn(_ txt: String) {
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 14.0)!,
            .foregroundColor: UIColor.white
        ]
        let attr = NSMutableAttributedString(string: txt, attributes: att)
        applyBtn.setAttributedTitle(attr, for: .normal)
    }
}

//MARK: - ButtonAnimationDelegate

extension BagPromoCodeCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Remove
            delegate?.removePromoCodeDidTap(self)
            
        } else if sender.tag == 2 { //Choose
            delegate?.choosePromoCodeDidTap(self)
        }
    }
}
