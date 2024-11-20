//
//  ProductDescriptionView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/04/2022.
//

import UIKit

class ProductDescriptionView: UIView {
    
    //MARK: - Properties
    let titleView = ViewAnimation()
    let titleLbl = UILabel()
    let iconImageView = UIImageView()
    let separatorView = UIView()
    let desLbl = UILabel()
    
    let titleHeight: CGFloat = 60.0
    var desHeight: CGFloat {
        var txt = desLbl.text ?? ""
        txt = txt == "" ? "DesjW" : txt
        return txt.estimatedTextRect(width: screenWidth-40, fontN: FontName.ppRegular, fontS: 14).height
    }
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

extension ProductDescriptionView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: titleHeight)
        heightConstraint.isActive = true
        
        //TODO: - DesTitleView
        titleView.clipsToBounds = true
        titleView.backgroundColor = .clear
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        
        //TODO: - DesTitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 20.0)
        titleLbl.textColor = .black
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        //TODO: - IconImageView
        let imgW: CGFloat = 15.0
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(named: "icon-rightArrow")?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .black
        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(iconImageView)
        
        //TODO: - SeparatorTopView
        setupSeparatorView(parentView: titleView, separatorView: separatorView)
        
        //TODO: - DesLbl
        desLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        desLbl.isHidden = true
        desLbl.textColor = .black
        desLbl.numberOfLines = 0
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        desLbl.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(desLbl)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20.0),
            titleLbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: imgW),
            iconImageView.heightAnchor.constraint(equalToConstant: imgW),
            iconImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20.0),
            
            separatorView.topAnchor.constraint(equalTo: titleView.topAnchor),
        ])
    }
    
    func updateHeight(_ vc: UIViewController, product: Product) {
        titleLbl.text = "Description".localized()
        desLbl.text = product.descriptionFull
        
        isHidden = product.descriptionFull == ""
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            vc.view.layoutIfNeeded()
        }
    }
    
    func hiddenDescription(_ vc: UIViewController, setHidden: Bool) {
        iconImageView.transform = setHidden ? CGAffineTransform(rotationAngle: .pi/2) : .identity
        desLbl.isHidden = !setHidden
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.heightConstraint.constant = self.titleHeight + (setHidden ? self.desHeight : 0.0)
            vc.view.layoutIfNeeded()
        }
    }
}

///Cho truy cập Product detail
func setupSeparatorView(parentView: UIView, separatorView: UIView) {
    separatorView.clipsToBounds = true
    separatorView.backgroundColor = separatorColor
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(separatorView)
    
    separatorView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    separatorView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
}
