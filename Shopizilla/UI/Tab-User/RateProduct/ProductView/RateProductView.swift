//
//  RateProductView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 05/05/2022.
//

import UIKit

class RateProductView: UIView {
    
    //MARK: - Properties
    let containerView = UIView()
    
    let coverView = UIView()
    let coverImageView = UIImageView()
    
    let nameLbl = UILabel()
    let priceLbl = UILabel()
    
    let colorTitleLbl = UILabel()
    let colorView = UIView()
    let colorInnerView = UIView()
    
    let halfLeftBorderImageView = UIImageView()
    let halfRightBorderImageView = UIImageView()
    
    let halfLeftImageView = UIImageView()
    let halfRightImageView = UIImageView()
    
    let sizeTitleLbl = UILabel()
    let sizeView = UIView()
    let sizeLbl = UILabel()
    
    var sizeWConstraint: NSLayoutConstraint!
    
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

extension RateProductView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: BagCVCell.coverH + 40).isActive = true
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15.0
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        setupShadow(containerView, radius: 1.0, opacity: 0.1)
        
        //TODO: - CoverView
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 15.0
        coverView.backgroundColor = .white
        coverView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coverView)
        setupShadow(coverView, radius: 1.0, opacity: 0.1)
        
        //TODO: - coverImageView
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 15.0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(coverImageView)
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        nameLbl.textColor = .darkGray
        nameLbl.numberOfLines = 2
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLbl)
        
        //TODO: - PriceLbl
        priceLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        priceLbl.textColor = .black
        priceLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(priceLbl)
        
        //TODO: - ColorTitleLbl
        setupTitle(lbl: colorTitleLbl, txt: "Color".localized())
        
        //TODO: - ColorView
        setupColorView(colorView, bgColor: .white)
        
        //TODO: - ColorInnerView
        setupColorView(colorInnerView, bgColor: .white, isCons: false)
        
        //TODO: - HalfLeftBorderImageView
        setupHalfBorderImageView(halfLeftBorderImageView, imgName: "icon-halfLeftBorder")
        
        //TODO: - HalfRightBorderImageView
        setupHalfBorderImageView(halfRightBorderImageView, imgName: "icon-halfRightBorder")
        
        //TODO: - HalfLeftImageView
        setupHalfImageView(halfLeftImageView, imgName: "icon-halfLeft")
        
        //TODO: - HalfRightImageView
        setupHalfImageView(halfRightImageView, imgName: "icon-halfRight")
        
        //TODO: - SizeTitleLbl
        setupTitle(lbl: sizeTitleLbl, txt: "Size".localized())
        
        //TODO: - SizeView
        sizeView.clipsToBounds = true
        sizeView.layer.cornerRadius = 6.0
        sizeView.layer.borderWidth = 1.5
        sizeView.layer.borderColor = UIColor.clear.cgColor
        sizeView.backgroundColor = defaultColor
        sizeView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sizeView)
        
        sizeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sizeWConstraint = sizeView.widthAnchor.constraint(equalToConstant: 30)
        sizeWConstraint.isActive = true
        
        setupShadow(sizeView, radius: 1.0, opacity: 0.1)
        
        //TODO: - SizeLbl
        sizeLbl.font = UIFont(name: FontName.ppSemiBold, size: 15.0)
        sizeLbl.textColor = .white
        sizeLbl.textAlignment = .center
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        sizeView.addSubview(sizeLbl)
        
        //TODO: - NSLayoutConstraint
        let sp: CGFloat = 4.0
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            containerView.heightAnchor.constraint(equalToConstant: BagCVCell.coverH),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            coverView.widthAnchor.constraint(equalToConstant: BagCVCell.coverW),
            coverView.heightAnchor.constraint(equalToConstant: BagCVCell.coverH),
            coverView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
            
            nameLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            nameLbl.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 10.0),
            nameLbl.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10.0),
            
            priceLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0),
            priceLbl.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 10.0),
            priceLbl.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10.0),
            
            colorTitleLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: appDL.isIPhoneX ? 5:0),
            colorTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            
            sizeTitleLbl.topAnchor.constraint(equalTo: colorTitleLbl.bottomAnchor, constant: 5.0),
            sizeTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            
            colorView.leadingAnchor.constraint(equalTo: colorTitleLbl.trailingAnchor, constant: 10.0),
            colorView.centerYAnchor.constraint(equalTo: colorTitleLbl.centerYAnchor),
            
            colorInnerView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: sp),
            colorInnerView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: sp),
            colorInnerView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -sp),
            colorInnerView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -sp),
            
            sizeView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            sizeView.centerYAnchor.constraint(equalTo: sizeTitleLbl.centerYAnchor),
            
            sizeLbl.topAnchor.constraint(equalTo: sizeView.topAnchor),
            sizeLbl.leadingAnchor.constraint(equalTo: sizeView.leadingAnchor),
            sizeLbl.trailingAnchor.constraint(equalTo: sizeView.trailingAnchor),
            sizeLbl.bottomAnchor.constraint(equalTo: sizeView.bottomAnchor),
        ])
    }
    
    private func setupTitle(lbl: UILabel, txt: String) {
        lbl.font = UIFont(name: FontName.ppMedium, size: 17.0)
        lbl.textColor = .darkGray
        lbl.text = txt
        lbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lbl)
        
        lbl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func setupColorView(_ colorView: UIView, bgColor: UIColor, isCons: Bool = true) {
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 6.0
        colorView.layer.borderWidth = 1.5
        colorView.layer.borderColor = UIColor.clear.cgColor
        colorView.backgroundColor = bgColor
        colorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorView)
        
        if isCons {
            colorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        setupShadow(colorView, radius: 1.0, opacity: 0.1)
    }
    
    private func setupHalfBorderImageView(_ imgView: UIImageView, imgName: String) {
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(imgView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: colorView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor)
        ])
    }
    
    private func setupHalfImageView(_ imgView: UIImageView, imgName: String) {
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        colorInnerView.addSubview(imgView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: colorInnerView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: colorInnerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: colorInnerView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: colorInnerView.bottomAnchor)
        ])
    }
    
    func updateUI(_ shopping: ShoppingCart) {
        coverImageView.image = nil
        
        DownloadImage.shared.downloadImage(link: shopping.imageURL) { image in
            self.coverImageView.image = image
        }
        
        nameLbl.text = shopping.name + " - \(shopping.category)"
        priceLbl.text = shopping.total.formattedCurrency
        sizeLbl.text = shopping.size
        
        let oneTxt = "ONE SIZE"
        let oneSizeW = oneTxt.estimatedTextRect(fontN: FontName.ppSemiBold, fontS: 15).width + 10
        sizeWConstraint.constant = shopping.size == oneTxt ? oneSizeW : 30
        
        colorView.layer.borderColor = UIColor.clear.cgColor
        colorInnerView.backgroundColor = .clear
        
        let component = shopping.color.components(separatedBy: ",")
        let first = (component.first ?? "").replacingOccurrences(of: " ", with: "")
        let last = (component.last ?? "").replacingOccurrences(of: " ", with: "")
        
        if component.count == 1 {
            if first.count == 6 {
                colorView.layer.borderColor = UIColor(hexStr: first).cgColor
                colorInnerView.backgroundColor = UIColor(hexStr: first)
                
                halfLeftBorderImageView.isHidden = true
                halfRightBorderImageView.isHidden = true
                
                halfLeftImageView.isHidden = true
                halfRightImageView.isHidden = true
            }
            
        } else if component.count == 2 {
            if first.count == 6 {
                halfLeftBorderImageView.isHidden = false
                halfLeftBorderImageView.tintColor = UIColor(hexStr: first)
                
                halfLeftImageView.isHidden = false
                halfLeftImageView.tintColor = UIColor(hexStr: first)
            }
            
            if last.count == 6 {
                halfRightBorderImageView.isHidden = false
                halfRightBorderImageView.tintColor = UIColor(hexStr: last)
                
                halfRightImageView.isHidden = false
                halfRightImageView.tintColor = UIColor(hexStr: last)
            }
        }
    }
}
