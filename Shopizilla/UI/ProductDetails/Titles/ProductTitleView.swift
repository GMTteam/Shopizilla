//
//  ProductTitleView.swift
//  Shopizilla
//
//  Created by Anh Tu on 24/04/2022.
//

import UIKit

class ProductTitleView: UIView {
    
    //MARK: - Properties
    let nameLbl = UILabel()
    
    private var nameHeight: CGFloat {
        var txt = nameLbl.text ?? ""
        txt = txt == "" ? "Wj" : txt
        return txt.estimatedTextRect(width: screenWidth-40, fontN: FontName.ppMedium, fontS: 20).height
    }
    var titleHeight: CGFloat {
        return nameHeight + 5
    }
    var titleHConstraint: NSLayoutConstraint!
    
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

extension ProductTitleView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        titleHConstraint = heightAnchor.constraint(equalToConstant: titleHeight)
        titleHConstraint.isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppMedium, size: 20.0)
        nameLbl.textColor = .gray
        nameLbl.numberOfLines = 0
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            nameLbl.topAnchor.constraint(equalTo: topAnchor),
            nameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            nameLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
        ])
    }
    
    func updateHeight(_ vc: UIViewController, product: Product) {
        nameLbl.text = product.name + " - " + product.productID
        titleHConstraint.constant = titleHeight
        
        isHidden = false
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            vc.view.layoutIfNeeded()
        }
    }
}
