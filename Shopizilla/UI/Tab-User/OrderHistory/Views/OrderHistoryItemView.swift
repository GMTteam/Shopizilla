//
//  OrderHistoryItemView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/05/2022.
//

import UIKit

class OrderHistoryItemView: UIView {
    
    //MARK: - Properties
    let coverView = UIView()
    let coverImageView = UIImageView()
    let nameLbl = UILabel()
    let newPriceLbl = UILabel()
    let oldPriceLbl = UILabel()
    
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

extension OrderHistoryItemView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoverView
        coverView.clipsToBounds = true
        coverView.backgroundColor = .white
        coverView.layer.cornerRadius = 15.0
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        setupShadow(coverView, radius: 1.0, opacity: 0.1)
        
        let coverW: CGFloat = screenWidth*0.2
        let coverH: CGFloat = coverW*imageHeightRatio
        coverView.widthAnchor.constraint(equalToConstant: coverW).isActive = true
        coverView.heightAnchor.constraint(equalToConstant: coverH).isActive = true
        
        //TODO: - ItemNameView
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        nameLbl.numberOfLines = 2
        nameLbl.textColor = .darkGray
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.widthAnchor.constraint(equalToConstant: screenWidth-100-coverW).isActive = true
        
        //TODO: - NewPriceLbl
        newPriceLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        newPriceLbl.textColor = .black
        
        //TODO: - PldPriceLbl
        oldPriceLbl.font = UIFont(name: FontName.ppSemiBold, size: 15.0)
        oldPriceLbl.textColor = .gray
        
        //TODO: - UIStackView
        let priceSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        priceSV.addArrangedSubview(newPriceLbl)
        priceSV.addArrangedSubview(oldPriceLbl)
        
        //TODO: - UIStackView
        let nameSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .leading)
        nameSV.addArrangedSubview(nameLbl)
        nameSV.addArrangedSubview(priceSV)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(coverView)
        stackView.addArrangedSubview(nameSV)
        addSubview(stackView)
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 15.0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(coverImageView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20.0),
            
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
        ])
    }
    
    func updateUI(_ shopping: ShoppingCart) {
        coverImageView.image = nil
        DownloadImage.shared.downloadImage(link: shopping.imageURL) { image in
            self.coverImageView.image = image
        }
        
        nameLbl.text = shopping.name + " - \(shopping.category)"
        
        let oldPrice = shopping.price
        let perc = (100 - shopping.saleOff)/100
        let newPrice = (oldPrice*perc)
        
        oldPriceLbl.text = ""
        oldPriceLbl.attributedText = nil

        if shopping.saleOff != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppSemiBold, size: 15.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldPrice.formattedCurrency, attributes: att)

            oldPriceLbl.attributedText = attr
        }

        oldPriceLbl.isHidden = shopping.saleOff == 0.0
        newPriceLbl.text = newPrice.formattedCurrency
    }
}
